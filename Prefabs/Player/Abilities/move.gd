extends MoveAbility

@export_category("Temp Stats")
@export var speed : float

func process(_ctx):
	pass

func move(direction:float) -> void:
	entity.velocity.x = direction * speed

func execute(direction :float):
	move(direction)
