extends Node2D

const keymap_path = "user://keymaps.data"
const interface_preference_path = "user://interface.data"
var interface_preference : Dictionary
var keymaps : Dictionary
@onready var binds = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl/Binds
@onready var tab_control = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl
@onready var use_animated_background = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl/Interface/AnimatedBackground
@onready var use_grid_for_notes = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl/Interface/UseGridForNotes
@onready var color_rect = $ParallaxBackground/ColorRect
@onready var color_rect_2 = $ParallaxBackground/ColorRect2
@onready var use_build_in_file_system = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl/Interface/UseBuildInFileSystem
@onready var open_user_theme_settings = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl/Interface/OpenUserThemeSettings
@onready var style_tab_container = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = Gset.AnimatedBG
	color_rect_2.visible = Gset.AnimatedBG
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			keymaps[action] = InputMap.action_get_events(action)[0]
	load_keymaps()
	load_interface()
	updbuttns()
	use_animated_background.button_pressed = interface_preference["animbg"]
	use_grid_for_notes.button_pressed = interface_preference["gridbg"]
	use_build_in_file_system.button_pressed = interface_preference["flsyst"]


func updbuttns():
	for n in binds.get_children():
		for f in n.get_children():
			if f.has_method("update_text"):
				f.update_text()

func load_keymaps():
	if not FileAccess.file_exists(keymap_path):
		save_keymaps()
		return
	var file = FileAccess.open(keymap_path,FileAccess.READ)
	var temp_keymap = file.get_var(true) as Dictionary
	file.close()
	for action in keymaps.keys():
		if temp_keymap.has(action):
			keymaps[action] = temp_keymap[action]
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action,keymaps[action])

func reset_keymaps():
	for action in keymaps.keys():
		match action:
			"movenotes":
				var Inpt = InputEventMouseButton.new()
				Inpt.button_index = 3
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"zoomin":
				var Inpt = InputEventMouseButton.new()
				Inpt.button_index = 4
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"zoomout":
				var Inpt = InputEventMouseButton.new()
				Inpt.button_index = 5
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"defzoom":
				var Inpt = InputEventKey.new()
				Inpt.keycode = 32
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"up":
				var Inpt = InputEventKey.new()
				Inpt.keycode = 4194320
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"down":
				var Inpt = InputEventKey.new()
				Inpt.keycode = 4194322
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"left":
				var Inpt = InputEventKey.new()
				Inpt.keycode = 4194319
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"right":
				var Inpt = InputEventKey.new()
				Inpt.keycode = 4194321
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
			"fastmv":
				var Inpt = InputEventKey.new()
				Inpt.keycode = 4194325
				keymaps[action] = Inpt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action,keymaps[action])
	updbuttns()
	save_keymaps()

func save_keymaps():
	var file = FileAccess.open(keymap_path,FileAccess.WRITE)
	file.store_var(keymaps,true)
	file.close()

func reset_interface():
	interface_preference["animbg"] = 1
	interface_preference["gridbg"] = 1
	interface_preference["flsyst"] = 1
	use_animated_background.button_pressed = interface_preference["animbg"]
	use_grid_for_notes.button_pressed = interface_preference["gridbg"]
	use_build_in_file_system.button_pressed = interface_preference["flsyst"]
	save_interface()

func load_interface():
	if not FileAccess.file_exists(interface_preference_path):
		reset_interface()
		return
	var file = FileAccess.open(interface_preference_path,FileAccess.READ)
	var temp_preference = file.get_var(true) as Dictionary
	file.close()
	interface_preference = temp_preference

func save_interface():
	var file = FileAccess.open(interface_preference_path,FileAccess.WRITE)
	file.store_var(interface_preference,true)
	file.close()
	use_animated_background.button_pressed = interface_preference["animbg"]
	use_grid_for_notes.button_pressed = interface_preference["gridbg"]
	Gset.AnimatedBG = interface_preference["animbg"]
	Gset.GridBG = interface_preference["gridbg"]
	Gset.BIFS = interface_preference["flsyst"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color_rect.visible = Gset.AnimatedBG
	color_rect_2.visible = Gset.AnimatedBG


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_reset_binds_button_pressed():
	reset_keymaps()


func _on_go_to_interface_pressed():
	tab_control.current_tab = 1


func _on_go_to_binding_pressed():
	tab_control.current_tab = 2


func _on_go_back_pressed():
	tab_control.current_tab = 0


func _on_animated_background_toggled(toggled_on):
	interface_preference["animbg"] = toggled_on
	save_interface()


func _on_use_grid_for_notes_toggled(toggled_on):
	interface_preference["gridbg"] = toggled_on
	save_interface()


func _on_reset_interface_pressed():
	reset_interface()


func _on_go_to_credits_pressed():
	tab_control.current_tab = 3


func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(str(meta))


func _on_use_build_in_file_system_toggled(toggled_on):
	interface_preference["flsyst"] = toggled_on
	save_interface()


func _on_theme_choose_button_item_selected(index):
	match index:
		0:
			open_user_theme_settings.visible = false
		1:
			open_user_theme_settings.visible = false
		2:
			open_user_theme_settings.visible = true


func _on_open_user_theme_settings_pressed():
	style_tab_container.current_tab = 1
