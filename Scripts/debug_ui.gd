extends CanvasLayer

const MISSING_VALUE := "--"
const PANEL_BG := Color(0.04, 0.05, 0.07, 0.58)
const CARD_BG := Color(0.09, 0.10, 0.13, 0.62)
const BORDER_COLOR := Color(0.30, 0.74, 0.86, 0.55)
const TEXT_COLOR := Color(0.86, 0.91, 0.95, 1.0)
const MUTED_TEXT_COLOR := Color(0.57, 0.65, 0.72, 1.0)
const ACCENT_COLOR := Color(0.50, 0.86, 0.95, 1.0)

var target: Entity:
	set(value):
		target = value
		if is_inside_tree():
			_rebuild_ability_debug_ui()

var fps_label: Label
var target_name_label: Label
var position_label: Label
var velocity_label: Label
var abilities_label: Label
var grounded_label: Label
var abilities_debug_container: HBoxContainer
var ability_filter_button: OptionButton

var ability_labels: Dictionary = {}
var ability_panels: Dictionary = {}
var selected_ability_name : String = "All"


func _ready() -> void:
	_build_debug_ui()
	_rebuild_ability_debug_ui()


func _process(_delta: float) -> void:
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

	if target == null:
		_set_empty_target_text()
		return

	debug_target_stats()
	debug_target_abilities()
	debug_ability_details()


func _build_debug_ui() -> void:
	for child in get_children():
		remove_child(child)
		child.free()

	var panel := PanelContainer.new()
	panel.name = "PanelContainer"
	panel.offset_left = 8.0
	panel.offset_top = 8.0
	panel.offset_right = 500.0
	panel.offset_bottom = 260.0
	panel.add_theme_stylebox_override("panel", _make_panel_style(PANEL_BG, BORDER_COLOR, 8, 1))
	add_child(panel)

	var margin := MarginContainer.new()
	margin.name = "MarginContainer"
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var target_debug_container := VBoxContainer.new()
	target_debug_container.name = "Target Debug Container"
	target_debug_container.add_theme_constant_override("separation", 3)
	margin.add_child(target_debug_container)

	_add_section_title(target_debug_container, "PLAYER")
	fps_label = _add_label(target_debug_container, "FPS")
	target_name_label = _add_label(target_debug_container, "Target Name")
	position_label = _add_label(target_debug_container, "Target Position")
	velocity_label = _add_label(target_debug_container, "Target Velocity")
	abilities_label = _add_label(target_debug_container, "Target Ability List")
	grounded_label = _add_label(target_debug_container, "Is Grounded")
	target_debug_container.add_child(HSeparator.new())
	_add_section_title(target_debug_container, "SETTINGS")
	ability_filter_button = _add_ability_filter(target_debug_container)
	target_debug_container.add_child(HSeparator.new())
	_add_section_title(target_debug_container, "ABILITIES")

	abilities_debug_container = HBoxContainer.new()
	abilities_debug_container.name = "Abilities Debug Container"
	abilities_debug_container.add_theme_constant_override("separation", 6)
	target_debug_container.add_child(abilities_debug_container)


func _rebuild_ability_debug_ui() -> void:
	if abilities_debug_container == null:
		return

	for child in abilities_debug_container.get_children():
		abilities_debug_container.remove_child(child)
		child.free()

	ability_labels.clear()
	ability_panels.clear()

	if target == null or target.ability_manager == null:
		_refresh_ability_filter()
		return

	var abilities: Dictionary = target.ability_manager.abilities
	for ability_name in abilities.keys():
		var ability: Ability = abilities[ability_name]
		var panel := PanelContainer.new()
		panel.name = "%s Ability Panel" % ability_name
		panel.custom_minimum_size = Vector2(150.0, 0.0)
		panel.add_theme_stylebox_override("panel", _make_panel_style(CARD_BG, Color(1, 1, 1, 0.12), 6, 1))
		abilities_debug_container.add_child(panel)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 6)
		margin.add_theme_constant_override("margin_top", 5)
		margin.add_theme_constant_override("margin_right", 6)
		margin.add_theme_constant_override("margin_bottom", 6)
		panel.add_child(margin)

		var column := VBoxContainer.new()
		column.name = "%s Ability" % ability_name
		column.add_theme_constant_override("separation", 2)
		margin.add_child(column)

		ability_panels[ability_name] = panel
		ability_labels[ability_name] = _build_labels_for_ability(column, ability)

	_refresh_ability_filter()
	_apply_ability_filter()


func _build_labels_for_ability(parent: VBoxContainer, ability: Ability) -> Dictionary:
	var labels := {}
	labels["name"] = _add_label(parent, "Ability Name")

	match ability.name:
		"Jump":
			labels["jump_strength"] = _add_label(parent, "Jump Strength")
			labels["jump_cut_multiplier"] = _add_label(parent, "Jump Cut")
			labels["is_jumping"] = _add_label(parent, "Jumping")
			labels["can_jump"] = _add_label(parent, "Can Jump")
			labels["coyote_time"] = _add_label(parent, "Coyote")
			labels["coyote_timer"] = _add_label(parent, "Coyote Left")
			labels["jump_buffer_time"] = _add_label(parent, "Buffer")
			labels["jump_buffer_timer"] = _add_label(parent, "Buffer Left")
		"Move":
			labels["speed"] = _add_label(parent, "Speed")
			labels["can_move"] = _add_label(parent, "Can Move")
			labels["move_direction"] = _add_label(parent, "Move Direction")
		"Dash":
			labels["dash_strength"] = _add_label(parent, "Dash Strength")
			labels["dash_time"] = _add_label(parent, "Dash Time")
			labels["is_dashing"] = _add_label(parent, "Dashing")
		_:
			labels["script"] = _add_label(parent, "Script")

	return labels


func _add_label(parent: Control, label_name: String) -> Label:
	var label := Label.new()
	label.name = label_name
	label.text = "%s: %s" % [label_name, MISSING_VALUE]
	label.add_theme_color_override("font_color", TEXT_COLOR)
	label.add_theme_font_size_override("font_size", 11)
	parent.add_child(label)
	return label


func _add_section_title(parent: Control, title: String) -> Label:
	var label := Label.new()
	label.name = title
	label.text = title
	label.add_theme_color_override("font_color", ACCENT_COLOR)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_constant_override("outline_size", 1)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.65))
	parent.add_child(label)
	return label


func _add_ability_filter(parent: Control) -> OptionButton:
	var button := OptionButton.new()
	button.name = "Ability Filter"
	button.custom_minimum_size = Vector2(150.0, 24.0)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_color_override("font_color", TEXT_COLOR)
	button.add_theme_color_override("font_hover_color", TEXT_COLOR)
	button.add_theme_color_override("font_pressed_color", TEXT_COLOR)
	button.item_selected.connect(_on_ability_filter_selected)
	parent.add_child(button)
	return button


func _refresh_ability_filter() -> void:
	if ability_filter_button == null:
		return

	ability_filter_button.clear()
	ability_filter_button.add_item("All")

	for ability_name in ability_panels.keys():
		ability_filter_button.add_item(ability_name)

	if selected_ability_name != "All" and !ability_panels.has(selected_ability_name):
		selected_ability_name = "All"

	for index in ability_filter_button.item_count:
		if ability_filter_button.get_item_text(index) == selected_ability_name:
			ability_filter_button.select(index)
			return


func _apply_ability_filter() -> void:
	for ability_name in ability_panels.keys():
		var panel: Control = ability_panels[ability_name]
		panel.visible = selected_ability_name == "All" or selected_ability_name == ability_name


func _on_ability_filter_selected(index: int) -> void:
	selected_ability_name = ability_filter_button.get_item_text(index)
	ability_filter_button.release_focus()
	_apply_ability_filter()


func _make_panel_style(bg_color: Color, border_color: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 0
	style.content_margin_top = 0
	style.content_margin_right = 0
	style.content_margin_bottom = 0
	return style


func _set_empty_target_text() -> void:
	target_name_label.text = "Target: %s" % MISSING_VALUE
	position_label.text = "Pos: %s" % MISSING_VALUE
	velocity_label.text = "Vel: %s" % MISSING_VALUE
	abilities_label.text = "Abilities: %s" % MISSING_VALUE
	grounded_label.text = "Floored: %s" % MISSING_VALUE


func debug_target_stats() -> void:
	target_name_label.text = "Target: %s" % target.name
	position_label.text = "Pos: %s" % target.global_position
	velocity_label.text = "Vel: %s" % target.velocity
	grounded_label.text = "Floored: %s" % target.is_on_floor()
	grounded_label.add_theme_color_override("font_color", ACCENT_COLOR if target.is_on_floor() else MUTED_TEXT_COLOR)


func debug_target_abilities() -> void:
	if target.ability_manager == null:
		abilities_label.text = "Abilities: %s" % MISSING_VALUE
		return

	var abilities: Dictionary = target.ability_manager.abilities
	abilities_label.text = "Abilities: %s" % ", ".join(abilities.keys())

	if _needs_ability_ui_rebuild(abilities):
		_rebuild_ability_debug_ui()


func debug_ability_details() -> void:
	if target.ability_manager == null:
		return

	var abilities: Dictionary = target.ability_manager.abilities
	for ability_name in abilities.keys():
		var ability: Ability = abilities[ability_name]
		var labels: Dictionary = ability_labels.get(ability_name, {})
		if labels.is_empty():
			continue

		labels["name"].text = "Ability: %s" % ability.name

		match ability.name:
			"Jump":
				_update_jump_ability_labels(ability, labels)
			"Move":
				_update_move_ability_labels(ability, labels)
			"Dash":
				_update_dash_ability_labels(ability, labels)
			_:
				labels["script"].text = "Script: %s" % ability.get_script().resource_path


func _update_jump_ability_labels(ability: Ability, labels: Dictionary) -> void:
	var coyote_timer: float = ability.get("coyote_timer")

	labels["jump_strength"].text = "Jump Strength: %s" % ability.get("jump_strength")
	labels["jump_cut_multiplier"].text = "Jump Cut: %s" % ability.get("jump_cut_multiplier")
	labels["is_jumping"].text = "Jumping: %s" % ability.get("is_jumping")
	labels["can_jump"].text = "Can Jump: %s" % (coyote_timer > 0.0)
	labels["is_jumping"].add_theme_color_override("font_color", ACCENT_COLOR if ability.get("is_jumping") else MUTED_TEXT_COLOR)
	labels["can_jump"].add_theme_color_override("font_color", ACCENT_COLOR if coyote_timer > 0.0 else MUTED_TEXT_COLOR)
	labels["coyote_time"].text = "Coyote: %s" % ability.get("coyote_time")
	labels["coyote_timer"].text = "Coyote Left: %s" % coyote_timer
	labels["jump_buffer_time"].text = "Buffer: %s" % ability.get("jump_buffer_time")
	labels["jump_buffer_timer"].text = "Buffer Left: %s" % ability.get("jump_buffer_timer")


func _update_move_ability_labels(ability: Ability, labels: Dictionary) -> void:
	var speed: float = ability.get("speed")

	labels["speed"].text = "Speed: %s" % speed
	labels["can_move"].text = "Can Move: %s" % (speed > 0.0)
	labels["move_direction"].text = "Move Direction: %s" % target.get("move_direction")
	labels["can_move"].add_theme_color_override("font_color", ACCENT_COLOR if speed > 0.0 else MUTED_TEXT_COLOR)


func _update_dash_ability_labels(ability: Ability, labels: Dictionary) -> void:
	labels["dash_strength"].text = "Dash Strength: %s" % ability.get("dash_strength")
	labels["dash_time"].text = "Dash Time: %s" % ability.get("dash_time")
	labels["is_dashing"].text = "Dashing: %s" % ability.get("is_dashing")
	labels["is_dashing"].add_theme_color_override("font_color", ACCENT_COLOR if ability.get("is_dashing") else MUTED_TEXT_COLOR)


func _needs_ability_ui_rebuild(abilities: Dictionary) -> bool:
	if ability_labels.size() != abilities.size():
		return true

	for ability_name in abilities.keys():
		if not ability_labels.has(ability_name):
			return true

	return false
