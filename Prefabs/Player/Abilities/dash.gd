extends DashAbility

var is_dashing : bool
@onready var dash_timer : Timer

func _ready():
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.wait_time = dash_time
	
	add_child(dash_timer)
	dash_timer.timeout.connect(self.exit_dash)

@export var dash_time : float = 0.3
@export var dash_strength : float = 700.0

func process(_ctx):
	dash(null)

func enter_dash():
	is_dashing = true
	dash_timer.start(dash_time)

func dash(_ctx) -> void:
	if is_dashing:
		entity.velocity.x = entity.face_direction * dash_strength

func exit_dash():
	is_dashing = false

func execute(_ctx):
	print("executing dash")
	enter_dash()
