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
