class_name  Player 
extends Entity

var face_direction : int
var move_direction : float :
	set(value):
		move_direction = value
		if value == 0 : return
		else : face_direction = sign(value)

func _physics_process(delta: float) -> void:
	request_jump(delta)
	request_move()
	ability_manager.process_abilities(delta)
	
	move_and_slide()

func request_jump(_delta:float)-> void :
	if Input.is_action_just_pressed("jump"):
		ability_manager.execute_jump(null)

func request_move() -> void :
	move_direction = Input.get_axis("move_left","move_right")
	ability_manager.execute_move(move_direction)
