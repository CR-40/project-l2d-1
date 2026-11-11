class_name GameLog
extends RefCounted

enum LogLevels { TRACE, DEBUG, INFO, WARNING, ERROR, CRITICAL, OFF }

## When enabled, every logger uses force_level and ignores its own level.
static var force_level_enabled: bool = false
static var force_level: LogLevels = LogLevels.INFO
## Per-node overrides by node name, e.g. { "Player": GameLog.LogLevels.TRACE }
static var overrides: Dictionary = {}

var _level: LogLevels
var _scope_ref: WeakRef

func _init(level: LogLevels, scope: Node) -> void:
	_level = level
	_scope_ref = weakref(scope)

func set_log_level(level: LogLevels) -> void:
	_level = level

func is_enabled(level: LogLevels) -> bool:
	if force_level_enabled:
		return level >= force_level
	if overrides.is_empty():
		return level >= _level
	return level >= overrides.get(_scope_name(), _level)

func _scope_name() -> String:
	var scope := _scope_ref.get_ref() as Node
	return String(scope.name) if scope else "<freed>"

func write(level: LogLevels, msg: Variant) -> void:
	if not is_enabled(level):
		return
	# A Callable is only evaluated when the message is actually logged
	var text := str(msg.call()) if msg is Callable else str(msg)
	var line := "[%d][%s][%s] => %s" % [
		Engine.get_physics_frames(), LogLevels.find_key(level), _scope_name(), text]
	print(line)
	if level == LogLevels.WARNING:
		push_warning(line)
	elif level >= LogLevels.ERROR:
		push_error(line)

func trace(msg: Variant) -> void: write(LogLevels.TRACE, msg)
func debug(msg: Variant) -> void: write(LogLevels.DEBUG, msg)
func info(msg: Variant) -> void: write(LogLevels.INFO, msg)
func warn(msg: Variant) -> void: write(LogLevels.WARNING, msg)
func error(msg: Variant) -> void: write(LogLevels.ERROR, msg)
func critical(msg: Variant) -> void: write(LogLevels.CRITICAL, msg)
