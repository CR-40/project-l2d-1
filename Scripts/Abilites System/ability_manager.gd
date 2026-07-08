class_name AbilityManager
extends Node

var abilities: Dictionary = {}
@onready var entity : Entity = $".."

func _ready() -> void:
	_load_Abilities(self)

func _load_Abilities(_abilities : Node) -> void :
	if _abilities == null:
		print("No Abilities found for ", entity.name, " or the Abilities Node is not set.")
		return
	
	for ability in get_children():
		if ability is Ability:
			ability.init(entity,self)
			abilities[ability.name] = ability

func process_abilities(delta):
	for ability: Ability in abilities.values():
		ability.process(delta)

func execute(ability: String, ctx):
	if abilities.has(ability): 
		abilities[ability].execute(ctx)
	else : print("Requested ability ["+ability+"] Not found, Execution not possiable")

# Talking with external systems
signal attack_resolution_requested(atk_ctx: AttackContext)

func resolve_attack(atk_ctx: AttackContext):
	attack_resolution_requested.emit(atk_ctx)
