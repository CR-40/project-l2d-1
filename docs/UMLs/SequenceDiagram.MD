# Player Sequence Diagrams

These diagrams show message order between the player, abilities, and game systems.

## Player Physics Frame

```mermaid
sequenceDiagram
    participant Godot
    participant Player
    participant AbilityManager
    participant Ability

    Godot->>Player: _physics_process(delta)
    Player->>Player: request_jump(delta)
    Player->>Player: request_move()
    Player->>Player: request_dash()
    Player->>Player: request_attack()
    Player->>AbilityManager: process_abilities(delta)

    loop each ability
        AbilityManager->>Ability: process(delta)
    end

    Player->>Player: move_and_slide()
```

## Ability Loading

```mermaid
sequenceDiagram
    participant Godot
    participant AbilityManager
    participant Ability
    participant Entity

    Godot->>AbilityManager: _ready()
    AbilityManager->>AbilityManager: _load_Abilities(self)

    loop each child node
        AbilityManager->>AbilityManager: check child is Ability
        AbilityManager->>Ability: init(entity, AbilityManager)
        Ability->>Entity: store entity reference
        Ability->>AbilityManager: store manager reference
        AbilityManager->>AbilityManager: abilities[ability.name] = ability
    end
```

## Jump Input

```mermaid
sequenceDiagram
    participant Input
    participant Player
    participant AbilityManager
    participant Jump

    Player->>Input: is_action_just_pressed("jump")

    alt jump pressed
        Player->>AbilityManager: execute("Jump", null)
        AbilityManager->>Jump: execute(null)
        Jump->>Jump: jump(null)
        Jump->>Jump: set jump_buffer_timer
    end

    Player->>AbilityManager: process_abilities(delta)
    AbilityManager->>Jump: process(delta)
    Jump->>Jump: update_coyote_timer(delta)
    Jump->>Jump: update_jump_buffer(delta)
    Jump->>Jump: resolve_jump()

    alt jump buffered and can jump
        Jump->>Jump: perform_jump()
        Jump->>Player: velocity.y = -jump_strength
    end

    opt jump released while rising
        Jump->>Player: velocity.y *= jump_cut_multiplier
    end
```

## Move Input

```mermaid
sequenceDiagram
    participant Input
    participant Player
    participant AbilityManager
    participant Move

    Player->>Input: get_axis("move_left", "move_right")
    Input-->>Player: move_direction
    Player->>Player: update face_direction if moving
    Player->>AbilityManager: execute("Move", face_direction)
    AbilityManager->>Move: execute(face_direction)
    Move->>Move: move(face_direction)
    Move->>Player: velocity.x = direction * speed
```

## Dash Input

```mermaid
sequenceDiagram
    participant Input
    participant Player
    participant AbilityManager
    participant Dash
    participant Timer

    Player->>Input: is_action_just_pressed("dash")

    alt dash pressed
        Player->>AbilityManager: execute("Dash", null)
        AbilityManager->>Dash: execute(null)
        Dash->>Dash: enter_dash()
        Dash->>Dash: is_dashing = true
        Dash->>Timer: start(dash_time)
    end

    Player->>AbilityManager: process_abilities(delta)
    AbilityManager->>Dash: process(delta)

    alt is_dashing
        Dash->>Player: velocity.x = face_direction * dash_strength
    end

    Timer-->>Dash: timeout
    Dash->>Dash: exit_dash()
    Dash->>Dash: is_dashing = false
```

## Attack Input

```mermaid
sequenceDiagram
    participant Input
    participant Player
    participant AbilityManager
    participant Attack
    participant Hitbox
    participant Target
    participant CombatSystem

    Player->>Input: check attack inputs
    Input-->>Player: atk_type
    Player->>AbilityManager: execute("attack", atk_type)
    AbilityManager->>Attack: execute(atk_type)
    Attack->>Hitbox: get_overlapping_bodies()
    Hitbox-->>Attack: bodies

    loop each body
        Attack->>Attack: skip self and non-Entity bodies

        alt body is valid Entity
            Attack->>Attack: construct_attack_context(body, atk_type)
            Attack->>AbilityManager: request_attack_resolution(atk_ctx)
            AbilityManager-->>CombatSystem: attack_resolution_requested(atk_ctx)
            CombatSystem->>Target: resolve damage/effects
        end
    end
```

Note: `Attack.resolve()` currently calls `ability_manager.resolve_attack(atk_ctx)`, but `AbilityManager` defines `request_attack_resolution(atk_ctx)`. This diagram shows the intended signal-based sequence.

## World Gravity And Player Movement

```mermaid
sequenceDiagram
    participant Godot
    participant World
    participant Entity
    participant Player

    Godot->>World: _physics_process(delta)

    loop each child in world
        World->>World: check child is Entity

        alt child is Entity and not on floor
            World->>Entity: velocity.y += GRAVITY
        else child is Entity and on floor
            World->>Entity: velocity.y = 0
        end
    end

    Godot->>Player: _physics_process(delta)
    Player->>Player: update requested movement
    Player->>Player: move_and_slide()
```
