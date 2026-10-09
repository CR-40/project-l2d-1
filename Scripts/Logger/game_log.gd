class_name GameLog
extends Node

enum LogLevels{
	TRACE,
	DEBUG,
	INFO,
	WARNING,
	ERROR,
	CRITICAL,
	OFF = 999
}

static var _global_log_level : LogLevels = LogLevels.INFO
static var _use_global_log_level : bool = false

var _log_level : LogLevels
var _scope : Node

func _init(level:LogLevels, scope:Node) -> void:
	setLogLevel(level)
	_scope = scope

func log(level:LogLevels, msg:String):
	var active_level := _global_log_level if _use_global_log_level else _log_level
	if  level < active_level : return
	print(
		"["+LogLevels.find_key(_log_level)+"]",
		"["+_scope.name+"] ",
		"=>",
		msg
		 )

func setLogLevel(level:LogLevels):
	_log_level = level

func trace(msg:String):
	self.log(LogLevels.TRACE, msg)
func debug(msg:String):
	self.log(LogLevels.DEBUG, msg)
func info(msg:String):
	self.log(LogLevels.INFO, msg)
func warn(msg:String):
	self.log(LogLevels.WARNING, msg)
func error(msg:String):
	self.log(LogLevels.ERROR, msg)
func critical(msg:String):
	self.log(LogLevels.CRITICAL, msg)
