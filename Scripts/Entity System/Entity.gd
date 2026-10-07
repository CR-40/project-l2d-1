## A game object thst exists in the world and participates in gameplay.
## [br]
## Stores
## [member stats], [member hitbox]
## [member ability_manager].

@abstract class_name Entity
extends CharacterBody2D

# Store stats 
@export var stats : BaseStats
@export var hitbox : Area2D

@export var ability_manager : AbilityManager
@export var animator : AnimatedSprite2D

func _ready() -> void:
	stats.report_death.connect(die)
	
	if ability_manager == null:
		print("[Entity: " +self.name+"]=> Ability Manager not found! Creating new one...")
		ability_manager = AbilityManager.new()
		ability_manager.name = "Ability Manager"
		
		add_child(ability_manager)

func take_damage(damage:float):
	stats.health -= damage
	#print("[Entity: " +self.name+"]=> took damage of "+ str(damage))
	#print("[Entity: " +self.name+"]=> Current Health is "+ str(stats.health))


func add_status_effect(_ctx):
	pass

func die():
	stats.report_death.disconnect(die)
	queue_free()
