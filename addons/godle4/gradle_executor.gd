@tool
extends Node

@onready var thread:Thread =Thread.new()
@onready var _mutex: Mutex = Mutex.new()

var is_running:bool = false:
	set(running):
		_mutex.lock()
		is_running = running
		_mutex.unlock()
		pass
	get:
		_mutex.lock()
		var res = is_running
		_mutex.unlock()
		return res

signal command_successful(arguments, output,identifier)
signal command_failed(arguments, output,identifier)

#The return value is weather or not it successfully executed.
func execute(path: String, arguments:Array, identifier = null)->bool:
	while is_running:
		return false
	_execute_shell_command(path, arguments, identifier)
	return true

func _execute_shell_command(path: String, arguments:Array, identifier):
	is_running = true
	
	thread.start(func():
		var output: Array = []
		var exit_code := OS.execute(path, arguments, output, true,true)
		if exit_code == 0:
			command_successful.emit(arguments,output,identifier)
		else:
			command_failed.emit(arguments,output,identifier)
		is_running = false
		_cleanup()
		pass)

func _cleanup():
	if thread== null:
		return
	if thread.is_alive() and not is_running:
		thread.wait_to_finish()
		thread = Thread.new()
	
func _exit_tree():
	_cleanup()
