extends Node

var abilities: Dictionary = {}
@onready var entity : Entity = $".."

func _ready() -> void:
	_load_Abilities(self)

func process_abilities(delta: float) -> void:
	if abilities.has("Jump"):
		abilities["Jump"].process(delta)

## Loads Abilities present under the Abilities Node.
## [br]
## This function iterates through the children of the provided Abilities Node and initializes any Ability components found, adding them to the entity's ability list.
## [br]
## [b]param:[/b] [code]abilities[/code] - The parent Node containing the components.
func _load_Abilities(_abilities : Node) -> void :
	if _abilities == null:
		print("No Abilities found for ", entity.name, " or the Abilities Node is not set.")
		return

	#for c in _abilities.get_children() :
		#if c is Ability: 
			#c.init(entity)
			#print("ability : ", c.name," is set")
			#ability.append(c)
			
	for c in get_children():
		if c is Ability:
			c.init(entity)
			abilities[c.name] = c

func execute_jump(ctx):
	$Jump.execute(ctx)

func execute_move(ctx):
	$Move.execute(ctx)
