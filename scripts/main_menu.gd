extends Node2D

const keymap_path = "user://keymaps.data"
const interface_preference_path = "user://interface.data"
const last_unsaved_session_path = "user://lastunsavedsession.data"
const last_sessions_array_path = "user://lastsessionsarray.data"
var lastsessionsarray : Array
var keymaps : Dictionary
var interface_preference : Dictionary
@onready var color_rect_2 = $ParallaxBackground/ColorRect2
@onready var color_rect = $ParallaxBackground/ColorRect
@onready var continue_button = $CanvasLayer/Control/VBoxContainer/Continue
@onready var note_trees_buttons = $"CanvasLayer/Control/Rescent note trees/Note Trees Buttons"
@onready var rescent_note_trees = $"CanvasLayer/Control/Rescent note trees"
@onready var message = $CanvasLayer/Control/Message

var desired_alpha = 0
var alpha_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pack_last_saved_sessions()
	check_last_unsaved_session()
	if Gset.temp_dic.size()>0:
		continue_button.visible = true
	else:
		continue_button.visible = false
	color_rect_2.visible = Gset.AnimatedBG
	color_rect.visible = Gset.AnimatedBG
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			keymaps[action] = InputMap.action_get_events(action)[0]
	load_keymaps()
	load_interface()
	get_tree().get_root().files_dropped.connect(on_files_drop)

func pack_last_saved_sessions():
	check_last_saved_sessions()
	for chlds in note_trees_buttons.get_children():
		chlds.queue_free()
	if lastsessionsarray.size() > 0:
		for i in lastsessionsarray.size():
			if i >= lastsessionsarray.size()-4 and i < lastsessionsarray.size():
				var nhbox = HBoxContainer.new()
				note_trees_buttons.add_child(nhbox)
				nhbox.add_theme_constant_override("separation",0)
				var snbut = Button.new()
				nhbox.add_child(snbut)
				snbut.text = " X "
				snbut.connect("pressed",Callable(self,"del_prev_note_in_history").bind(lastsessionsarray[i]))
				var nbut = Button.new()
				nhbox.add_child(nbut)
				nbut.text = lastsessionsarray[i]
				nbut.alignment = HORIZONTAL_ALIGNMENT_LEFT
				nbut.connect("pressed",Callable(self,"ld_prev_note").bind(lastsessionsarray[i]))
				nbut.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func on_files_drop(files):
	var path : String = files[0]
	match path.get_extension():
		"notdat":
			if FileAccess.file_exists(path):
				var file = FileAccess.open(path,FileAccess.READ)
				var temp_session_arr = file.get_var(true) as Array
				if temp_session_arr.size()>0:
					Gset.temp_dic = temp_session_arr
				get_tree().change_scene_to_file("res://scenes/note_basis.tscn")
			else:
				alpha_timer = 2

func del_prev_note_in_history(lstpath):
	lastsessionsarray.erase(lstpath)
	var tfile = FileAccess.open(last_sessions_array_path,FileAccess.WRITE)
	tfile.store_var(lastsessionsarray,true)
	tfile.close()
	for chld in note_trees_buttons.get_children():
		chld.queue_free()
	pack_last_saved_sessions()

func ld_prev_note(lstpath):
	if FileAccess.file_exists(lstpath):
		var file = FileAccess.open(lstpath,FileAccess.READ)
		var temp_session_arr = file.get_var(true) as Array
		if temp_session_arr.size()>0:
			Gset.temp_dic = temp_session_arr
		get_tree().change_scene_to_file("res://scenes/note_basis.tscn")
	else:
		del_prev_note_in_history(lstpath)
		alpha_timer = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if note_trees_buttons.get_child_count() > 0:
		rescent_note_trees.visible = true
	else:
		rescent_note_trees.visible = false
	color_rect_2.visible = Gset.AnimatedBG
	color_rect.visible = Gset.AnimatedBG
	alpha_timer = move_toward(alpha_timer,0,delta)
	if alpha_timer>0:
		desired_alpha = move_toward(desired_alpha,1,delta*4)
	else:
		desired_alpha = move_toward(desired_alpha,0,delta)
	message.modulate.a = clampf(desired_alpha,0,1)

func check_last_unsaved_session():
	if FileAccess.file_exists(last_unsaved_session_path):
		var file = FileAccess.open(last_unsaved_session_path,FileAccess.READ)
		var temp_session_arr = file.get_var(true) as Array
		if temp_session_arr.size()>0:
			Gset.temp_dic = temp_session_arr

func check_last_saved_sessions():
	if FileAccess.file_exists(last_sessions_array_path):
		var file = FileAccess.open(last_sessions_array_path,FileAccess.READ)
		var temp_session_arr = file.get_var(true) as Array
		if temp_session_arr.size()>0:
			lastsessionsarray = temp_session_arr

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

func save_keymaps():
	var file = FileAccess.open(keymap_path,FileAccess.WRITE)
	file.store_var(keymaps,true)
	file.close()


func reset_interface():
	interface_preference["animbg"] = 1
	interface_preference["gridbg"] = 1
	interface_preference["flsyst"] = 1
	Gset.AnimatedBG = interface_preference["animbg"]
	Gset.GridBG = interface_preference["gridbg"]
	Gset.BIFS = interface_preference["flsyst"]

func load_interface():
	if not FileAccess.file_exists(interface_preference_path):
		reset_interface()
		return
	var file = FileAccess.open(interface_preference_path,FileAccess.READ)
	var temp_preference = file.get_var(true) as Dictionary
	file.close()
	interface_preference = temp_preference
	Gset.AnimatedBG = interface_preference["animbg"]
	Gset.GridBG = interface_preference["gridbg"]
	Gset.BIFS = interface_preference["flsyst"]


func _on_go_nots_pressed():
	get_tree().change_scene_to_file("res://scenes/note_basis.tscn")
	Gset.temp_dic = []

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings.tscn")



func _on_exit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/note_basis.tscn")



func _on_rescent_notes_button_toggled(toggled_on):
	note_trees_buttons.visible = toggled_on
