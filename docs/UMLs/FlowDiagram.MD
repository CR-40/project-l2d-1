# Player Flow Diagrams

These diagrams show how the player script drives abilities each physics frame.

## Player Physics Frame

```mermaid
flowchart TD
    A[Godot physics frame] --> B[Player._physics_process delta]

    B --> C[request_jump]
    C --> D[request_move]
    D --> E[request_dash]
    E --> F[request_attack]

    F --> G[AbilityManager.process_abilities delta]
    G --> H[Each ability runs process delta]
    H --> I[Player.move_and_slide]
```

## Ability Request Flow

```mermaid
flowchart TD
    A[Player input check] --> B{Which action?}

    B -->|jump pressed| C[AbilityManager.execute Jump, null]
    B -->|move left/right axis| D[Set move_direction]
    D --> E[Update face_direction if moving]
    E --> F[AbilityManager.execute Move, face_direction]

    B -->|dash pressed| G[AbilityManager.execute Dash, null]

    B -->|attack pressed| H[atk_type = simple attack]
    B -->|power attack pressed| I[atk_type = power attack]
    B -->|special attack pressed| J[atk_type = special attack]

    H --> K[AbilityManager.execute attack, atk_type]
    I --> K
    J --> K

    C --> L[Ability execute]
    F --> L
    G --> L
    K --> L
```

## Jump Flow

```mermaid
flowchart TD
    A[Player presses jump] --> B[request_jump]
    B --> C[AbilityManager.execute Jump]
    C --> D[Jump.execute]
    D --> E[Set jump_buffer_timer]

    F[AbilityManager.process_abilities] --> G[Jump.process delta]
    G --> H{Player on floor?}
    H -->|yes| I[Reset coyote_timer]
    H -->|no| J[Decrease coyote_timer]

    I --> K[Decrease jump_buffer_timer]
    J --> K
    K --> L{Jump buffered?}
    L -->|no| M[No jump]
    L -->|yes| N{Can jump?}
    N -->|no| M
    N -->|yes| O[perform_jump]
    O --> P[Set velocity.y = -jump_strength]
    P --> Q[Clear jump buffer and coyote timer]

    G --> R{Jump released while rising?}
    R -->|yes| S[Cut upward velocity]
    R -->|no| T[Keep current jump]
```

## Move Flow

```mermaid
flowchart TD
    A[Physics frame] --> B[request_move]
    B --> C[Read Input.get_axis move_left, move_right]
    C --> D[Set move_direction]
    D --> E{move_direction is 0?}
    E -->|yes| F[Keep previous face_direction]
    E -->|no| G[face_direction = sign move_direction]

    F --> H[AbilityManager.execute Move, face_direction]
    G --> H
    H --> I[Move.execute]
    I --> J[Move.move direction]
    J --> K[entity.velocity.x = direction * speed]
```

## Dash Flow

```mermaid
flowchart TD
    A[Player presses dash] --> B[request_dash]
    B --> C[AbilityManager.execute Dash]
    C --> D[Dash.execute]
    D --> E[enter_dash]
    E --> F[is_dashing = true]
    F --> G[Start dash_timer]

    H[AbilityManager.process_abilities] --> I[Dash.process]
    I --> J{is_dashing?}
    J -->|yes| K[velocity.x = face_direction * dash_strength]
    J -->|no| L[No dash movement]

    G --> M[Timer timeout]
    M --> N[exit_dash]
    N --> O[is_dashing = false]
```

## Attack Flow

```mermaid
flowchart TD
    A[Player presses attack input] --> B[request_attack]
    B --> C{Which attack input?}

    C -->|attack| D[atk_type = simple attack]
    C -->|power attack| E[atk_type = power attack]
    C -->|special attack| F[atk_type = special attack]
    C -->|none| G[atk_type remains empty]

    D --> H[AbilityManager.execute attack, atk_type]
    E --> H
    F --> H
    G --> H

    H --> I[Attack.execute]
    I --> J[Get bodies from player hitbox]
    J --> K{Any overlapping bodies?}
    K -->|no| L[Stop]
    K -->|yes| M[Loop through bodies]

    M --> N{Is body the player?}
    N -->|yes| M
    N -->|no| O{Is body an Entity?}
    O -->|no| M
    O -->|yes| P[Build AttackContext]
    P --> Q[attacker = player]
    Q --> R[target = body]
    R --> S[attack_type = atk_type]
    S --> T[Resolve attack]
    T --> U[AbilityManager emits attack_resolution_requested]
    U --> V[CombatSystem.resolve atk_ctx]
```

Note: `Attack.resolve()` currently calls `ability_manager.resolve_attack(atk_ctx)`, while `AbilityManager` defines `request_attack_resolution(atk_ctx)`. The final two nodes show the intended signal flow.

## World Gravity Around Player

```mermaid
flowchart TD
    A[World._physics_process] --> B[Loop world children]
    B --> C{Child is Entity?}
    C -->|no| B
    C -->|yes| D[add_gravity entity]

    D --> E{Entity is on floor?}
    E -->|no| F[velocity.y += GRAVITY]
    E -->|yes| G[velocity.y = 0]

    F --> B
    G --> B
```
