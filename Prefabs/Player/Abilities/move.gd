extends MoveAbility
var logger: GameLog = GameLog.new(GameLog.LogLevels.TRACE, self)

@export_category("Movement Stats")
@export var max_speed : float = 300
## braking when input opposes motion
@export var turn_acceleration : float = 5000  

@export_group("Ground Movement")
@export var acceleration : float = 4000
@export var deceleration : float = 5000

@export_group("Air Movement")
@export var in_air_acceleration : float = 2700
@export var in_air_deceleration : float = 3333

var direction : float

func process(delta: float) -> void:
	var vx := entity.velocity.x
	if entity.is_on_floor():
		handle_ground_movement(vx, delta)
	else: 
		handle_air_movement(vx, delta)

 
func handle_ground_movement(vx : float, delta):
	if direction == 0.0:
		entity.velocity.x = move_toward(vx, 0.0, deceleration * delta)
	else:
		var accel := acceleration
		if vx != 0.0 and signf(direction) != signf(vx):
			accel = turn_acceleration
		entity.velocity.x = move_toward(vx, direction * max_speed, accel * delta)
func handle_air_movement(vx : float, delta):
	if direction == 0.0:
		entity.velocity.x = move_toward(vx, 0.0, in_air_deceleration * delta)
	else:
		var accel := in_air_acceleration
		if vx != 0.0 and signf(direction) != signf(vx):
			accel = turn_acceleration
		entity.velocity.x = move_toward(vx, direction * max_speed, accel * delta)

func move(_direction:float) -> void:
	direction = _direction

func execute(_direction :float):
	move(_direction)
