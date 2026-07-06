@abstract class_name Ability
extends Node

var entity : Entity
var ability_manager : AbilityManager

func init(_entity : Entity, _AM : AbilityManager) -> void:
	entity = _entity
	ability_manager = _AM

@abstract func process(ctx)

@abstract func execute(ctx)
