extends JumpAbility

## Handles jump input buffering and coyote time for an [Entity].[br]
## [Entity] extends [CharacterBody2D], so this ability can read floor state with
## [code]entity.is_on_floor()[/code] and apply jump movement through
## [code]entity.velocity[/code].
@export_category("Temp Stats")
## Upward velocity applied when the jump is performed.[br]
## Larger values make the [Entity] jump higher.
@export var jump_strength : float = 1000
## Grace period, in seconds, where jumping is still allowed after leaving the floor.[br]
## This makes jumps feel more forgiving when the player presses jump slightly late.
@export var coyote_time: float = 0.15
## Time, in seconds, that a jump input is remembered before expiring.[br]
## This makes jumps feel more forgiving when the player presses jump slightly early.
@export var jump_buffer_time: float = 0.10

## Remaining coyote-time window.[br]
## Refreshed while grounded and reduced while airborne.
var coyote_timer: float = 0.0
## Remaining buffered-jump window.[br]
## Filled by jump input and consumed by a valid jump.
var jump_buffer_timer: float = 0.0


## Ability entry point called by [code]AbilityManager[/code] when the [Entity] receives jump input.[br]
## [param ctx] Optional ability context. Currently forwarded to [method jump].
func execute(ctx) -> void:
	jump(ctx)


## Updates timers each physics frame and performs a queued jump if the [Entity] can jump.[br]
## [param delta] Time passed since the previous physics frame.
func process(delta: float) -> void:
	_update_timers(delta)
	_resolve_jump_request()


## Queues a jump request by filling [member jump_buffer_timer].[br]
## [param _ctx] Optional ability context. Currently unused.
func jump(_ctx) -> void:
	jump_buffer_timer = jump_buffer_time


## Consumes a buffered jump request when the [Entity] is allowed to jump.[br]
## Does nothing if [member jump_buffer_timer] has expired or coyote time is invalid.
func _resolve_jump_request() -> void:
	if jump_buffer_timer <= 0.0:
		return

	if !_can_jump():
		return

	_perform_jump()


## Applies jump velocity to the [Entity] and clears timers to prevent repeat jumps.[br]
## Writes to [code]entity.velocity.y[/code], inherited from [CharacterBody2D].
func _perform_jump() -> void:
	entity.velocity.y = -jump_strength
	jump_buffer_timer = 0.0
	coyote_timer = 0.0


## Returns whether the [Entity] is currently inside a valid jump window.[br]
## The jump is valid while [member coyote_timer] is greater than [code]0.0[/code].
func _can_jump() -> bool:
	return coyote_timer > 0.0


## Updates all jump timers once per physics frame.[br]
## [param delta] Time passed since the previous physics frame.
func _update_timers(delta: float) -> void:
	_update_coyote_timer(delta)
	_update_jump_buffer(delta)


## Refreshes coyote time on the floor, otherwise counts it down while in the air.[br]
## [param delta] Time passed since the previous physics frame.
func _update_coyote_timer(delta: float) -> void:
	if entity.is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)


## Counts down the buffered jump request until it expires.[br]
## [param delta] Time passed since the previous physics frame.
func _update_jump_buffer(delta: float) -> void:
	jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)
