class_name AbilityManager
extends Node
var logger:GameLog = GameLog.new(GameLog.LogLevels.DEBUG, self)

@onready var entity : Entity = $".."

@export var abilities: Dictionary[String, Ability] = {}

func _ready() -> void:
	_load_Abilities()

func _load_Abilities() -> void :
	var _abilities = get_children()
	logger.debug("[Entity: "+entity.name+"] - Loading abilities... ")
	
	if _abilities == []:
		logger.warn("No Abilities found for <"+entity.name+"> or the Abilities Node is not set.")
		logger.debug("---finished--xx \n ")
		return
	
	for ability in _abilities:
		logger.trace("Itterating on: "+ ability.name)
		if ability is Ability:
			ability.init(entity,self)
			abilities[ability.name] = ability
			logger.debug("Ablity set ["+ability.name+"]")
	
	logger.debug("---finished--xx \n ")

func process_abilities(delta):
	for ability: Ability in abilities.values():
		ability.process(delta)

func execute(ability: String, ctx):
	if abilities.has(ability): 
		abilities[ability].execute(ctx)
	else : logger.debug("Requested ability ["+ability+"] Not found, Execution not possiable")

# Talking with external systems
signal attack_resolution_requested(atk_ctx: AttackContext)

func resolve_attack(atk_ctx: AttackContext):
	attack_resolution_requested.emit(atk_ctx)
