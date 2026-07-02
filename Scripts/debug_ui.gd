extends CanvasLayer

@onready var fps_label: Label = $PanelContainer/MarginContainer/VBoxContainer/FPS
@onready var position_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Position
@onready var velocity_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Velocity
@onready var abilities_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Abilities
@onready var cayote_time: Label = $"PanelContainer/MarginContainer/VBoxContainer/cayote time"
@onready var jump_buffer: Label = $PanelContainer/MarginContainer/VBoxContainer/jump_buffer
@onready var floored: Label = $PanelContainer/MarginContainer/VBoxContainer/Floored

var target: Entity

func _process(_delta: float) -> void:
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

	if target == null:
		return

	position_label.text = "Pos: %s" % target.global_position
	velocity_label.text = "Vel: %s" % target.velocity

	cayote_time.text = "Caoyote Time: %s" % target.ability_manager.abilities["Jump"].coyote_timer 
	jump_buffer.text = "Jump Buffer Timer: %s" % target.ability_manager.abilities["Jump"].jump_buffer_timer
	print("Jump Buffer Timer: %s" % target.ability_manager.abilities["Jump"].jump_buffer_timer)
	
	floored.text = "Floored : %s" % target.is_on_floor()
