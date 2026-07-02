extends Node

@export var GRAVITY : float

@export var debug_target : Entity
@onready var debug_ui := $"Debug UI"

func _ready() -> void:
	debug_ui.target = debug_target

func _physics_process(delta: float) -> void:
	var bodies = self.get_children()
	for body in bodies :
		if body is Entity: add_gravity(body)

func add_gravity(body: Entity):
	#print("Adding gravity [",body.name,"]")
	if not body.is_on_floor():
		body.velocity.y += GRAVITY 
		#print("gravity added ",GRAVITY)
		#print("current velocity in y ", body.velocity.y)
	else:
		body.velocity.y = 0
		#print("gravity set to 0")
