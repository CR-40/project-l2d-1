extends Node

@export var GRAVITY : float = 0

@export var combat_system : Node
@export var player : Entity
@export var debug_target : Entity

func _ready() -> void:
	player.ability_manager.attack_resolution_requested.connect(combat_system.resolve)

func _physics_process(_delta: float) -> void:
	var bodies = self.get_children()
	for body in bodies :
		if body is Entity: add_gravity(body, _delta)

func add_gravity(body: Entity, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y += GRAVITY * delta
	else:
		body.velocity.y = 0.0
