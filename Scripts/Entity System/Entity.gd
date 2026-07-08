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

func _ready() -> void:
	stats.report_death.connect(die)

func take_damage(damage:float):
	stats.health -= damage

func add_status_effect(_ctx):
	pass

func die():
	stats.report_death.disconnect(die)
	queue_free()
