@tool
extends CheckBox
const setting_name = "gradle/offline_mode"

# Called when the node enters the scene tree for the first time.
func _ready():
	if not ProjectSettings.has_setting(setting_name):
		ProjectSettings.set(setting_name,false)
		ProjectSettings.set_initial_value(setting_name,false)
	button_pressed = ProjectSettings.get_setting(setting_name,false)
	set_tooltip()
	pass
	
func set_tooltip():
	if button_pressed:
		tooltip_text = "offline mode: offline"
	else:
		tooltip_text = "offline mode: online"
	

func _process(delta):
	pass


#Update the hints so the user can know what is happening.
func _on_pressed():
	ProjectSettings.set(setting_name,button_pressed)
	ProjectSettings.save()
	set_tooltip()
