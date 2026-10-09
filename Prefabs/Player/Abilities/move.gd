extends MoveAbility

@export_category("Temp Stats")
@export var speed : float
@export var max_speed : float
@export var accleration : float
@export var decelerate : float

func process(_ctx):
	pass

func move(direction:float) -> void:
	if entity.velocity.x > max_speed && direction != 0:
		entity.velocity.x = max_speed
	else : entity.velocity.x += direction * accleration
	
	if direction == 0 && entity.velocity.x != 0:
		entity.velocity.x -= direction * accleration

func execute(direction :float):
	move(direction)
