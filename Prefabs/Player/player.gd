class_name  Player 
extends Entity
var logger:GameLog = GameLog.new(GameLog.LogLevels.OFF, self)

var is_attacking : bool = false
 
func _physics_process(delta: float) -> void:
	request_jump(delta)
	request_move()
	handle_flip()
	
	request_dash()
	request_attack()
	
	ability_manager.process_abilities(delta)
	
	move_and_slide()

func handle_flip():
	if face_direction > 0:
		hitbox.scale.x = 1
	if face_direction < 0:
		hitbox.scale.x = -1

func request_jump(_delta:float)-> void :
	if Input.is_action_just_pressed("jump"):
		logger.trace("Jump Requested")
		ability_manager.execute("Jump",null)

func request_move() -> void :
	move_direction = Input.get_axis("move_left","move_right")
	ability_manager.execute("Move",move_direction)

func request_dash() -> void :
	if Input.is_action_just_pressed("dash"):
		logger.debug("Requesting Dash")
		ability_manager.execute("Dash",null)

func request_attack() -> void :
	var atk_type 
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		atk_type = "simple attack"
	
	#elif Input.is_action_just_pressed("power attack"): 
		#is_attacking = true
		#atk_type = "power attack"
	
	#elif Input.is_action_just_pressed("special attack"):
		#is_attacking = true
		#atk_type = "special attack"
	
	if is_attacking : ability_manager.execute("Attack",atk_type)
