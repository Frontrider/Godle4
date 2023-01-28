@tool
extends EditorPlugin
var GodlePanel = preload("res://addons/godle4/panel/godle_panel.tscn")

var godle_panel = GodlePanel.instantiate()

func _enter_tree():
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL,godle_panel)
	# Initialization of the plugin goes here.
	pass


func _exit_tree():
	remove_control_from_docks(godle_panel)
	godle_panel.queue_free()
	# Clean-up of the plugin goes here.
	pass
