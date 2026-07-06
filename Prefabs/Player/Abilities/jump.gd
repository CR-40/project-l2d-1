extends JumpAbility

var is_jumping : bool
var coyote_timer : float = 0.0
var jump_buffer_timer : float = 0.0

@export var jump_strength : float
@export var jump_cut_multiplier : float = 0.5
@export var coyote_time : float = 0.15
@export var jump_buffer_time : float = 0.10

func process(delta):
	update_coyote_timer(delta)
	update_jump_buffer(delta)
	resolve_jump()
	variable_jump(null)

func update_coyote_timer(delta) -> void:
	if entity.is_on_floor():
		is_jumping = false
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)

func update_jump_buffer(delta) -> void:
	jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

func resolve_jump() -> void:
	if jump_buffer_timer <= 0.0: return
	if !can_jump(): return
	perform_jump()

func jump(_ctx) -> void:
	jump_buffer_timer = jump_buffer_time

func variable_jump(_ctx) -> void:
	if !is_jumping: return
	if !Input.is_action_just_released("jump"): return
	if entity.velocity.y >= 0.0: return
	entity.velocity.y *= jump_cut_multiplier

func can_jump() -> bool:
	return coyote_timer > 0.0

func perform_jump() -> void:
	is_jumping = true
	entity.velocity.y = -jump_strength
	jump_buffer_timer = 0.0
	coyote_timer = 0.0

func execute(_ctx):
	print("executing jump")
	jump(null)
