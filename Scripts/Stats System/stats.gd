class_name BaseStats
extends Resource

@export_group("Base Stats")
@export var BaseHealth: float = 100.0
@export var BaseAttack: float = 10.0
@export var BaseDefense: float = 5.0

@export_group("Stats")
@export var health: float :
	set(value):
		health = process_health_change(value)
	get:
		return health

@export var attack: float
@export var defense: float 

signal health_changed(new_health)
signal health_decreased(new_health)
signal health_increased(new_health)
signal report_death()

func process_health_change(value) -> float :
	var new_health : float = clamp(value,0,BaseHealth)
	if health == new_health : return new_health
	
	health_changed.emit(new_health)
	if new_health < health : health_decreased.emit(new_health)
	if new_health > health : health_increased.emit(new_health)
	if new_health <= 0 : report_death.emit()
	return new_health
