@tool
extends VBoxContainer

@onready var task_tree = $ScrollContainer/TaskTree
@onready var offline_mode = $Panel/HBoxContainer/OfflineMode
@onready var executor = $GradleExecutor
@onready var refresh_button = $Panel/HBoxContainer/Refresh

var task_items = []
# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()
	pass

func refresh():
	var args = ["--init-script","./addons/godle4/.godle.init.gradle.kts","-q","godleDumpTasks"]
	_start_execution(args,"init")
	pass
	
func _start_execution(args:Array,identifier):
	#If offline mode is enabled in the editor, enable it.
	if offline_mode.pressed:
		args.append("--offline")
	if executor.execute("./gradlew",args,identifier):
		refresh_button.disabled = true
	pass

func setup_task_tree(root:TreeItem,data):
	var item = task_tree.create_item(root) as TreeItem
	item.set_text(0,data["projectName"])
	var tasks = task_tree.create_item(item) as TreeItem
	tasks.set_text(0,"Tasks")
	var task_groups = data["tasks"].keys()
	task_groups.sort()
	tasks.collapsed = true
	for group in task_groups:
		var group_item = task_tree.create_item(tasks) as TreeItem
		group_item.set_text(0,group)
		for task in data["tasks"][group]:
			var task_item = task_tree.create_item(group_item) as TreeItem
			task_item.set_text(0,task["name"])
			if task.has("description"):
				task_item.set_tooltip_text(0,task["description"])
				task_items.append(task_item)
				pass
			pass
		group_item.collapsed = true
		pass
	root.collapsed = true
	for subproject in data["subprojects"]:
		setup_task_tree(item,subproject)
		pass
	pass


func _on_task_tree_item_activated():
	var selected = task_tree.get_selected() as TreeItem
	#If the selected item is not a task, then we can't run it.
	#We check if it is in the stored task array.
	if(task_items.find(selected) == -1):
		return
	var task = selected.get_text(0)
	var args = [task]
	_start_execution(args,"task")
	print("Executing gradle task: "+task)
	pass


func _on_gradle_executor_command_successful(arguments, output,identifier):
	if(identifier == "init"):
		var gradle_data = JSON.parse_string(output[0])
		task_items.clear()
		task_tree.clear()
		setup_task_tree(null,gradle_data)
		print("gradle refreshed")
	else:
		for line in output:
			if not line.is_empty():
				print(line)
	refresh_button.disabled = false
	pass

func _on_gradle_executor_command_failed(arguments, output,identifier):
	printerr("Failed to load gradle project!")
	for line in output:
		if not line.is_empty():
			printerr(line)
	refresh_button.disabled = false
	pass
