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
	request_dash()
	request_attack()
	
	ability_manager.process_abilities(delta)
	
	move_and_slide()

func request_jump(_delta:float)-> void :
	if Input.is_action_just_pressed("jump"):
		ability_manager.execute("Jump",null)

func request_move() -> void :
	move_direction = Input.get_axis("move_left","move_right")
	ability_manager.execute("Move",face_direction)

func request_dash() -> void :
	if Input.is_action_just_pressed("dash"):
		print("Requesting Dash")
		ability_manager.execute("Dash",null)

func request_attack() -> void :
	var atk_type 
	if Input.is_action_just_pressed("attack"): atk_type = "simple attack"
	elif Input.is_action_just_pressed("power attack"): atk_type = "power attack"
	elif Input.is_action_just_pressed("special attack"): atk_type = "special attack"
	ability_manager.execute("attack",atk_type)
