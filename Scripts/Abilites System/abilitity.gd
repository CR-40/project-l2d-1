@abstract class_name Ability
extends Node

var entity : Entity

func init(_entity : Entity) -> void:
	entity = _entity

@abstract func execute(ctx)
