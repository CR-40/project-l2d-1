class_name HitData
extends RefCounted

var attacker : Entity
var target : Entity

var damage : float
var knockback : Vector2
var critical : bool

var applied_status_effects : Array

var tags : Array[StringName]
