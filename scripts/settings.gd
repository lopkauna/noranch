extends Node2D

const keymap_path = "user://keymaps.data"
const interface_preference_path = "user://interface.data"
const current_user_theme_path = "user://curtheme.nrchthem"
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
@onready var theme_choose_button = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/MarginContainer/TabControl/Interface/ThemeChooseButton
@onready var decoy_panel = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/MarginContainer/MarginContainer/Panel
@onready var decoy_label = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/MarginContainer/MarginContainer/MarginContainer/FlowContainer/DecoyLabel
@onready var decoy_text_edit = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/MarginContainer/MarginContainer/MarginContainer/FlowContainer/DecoyTextEdit
@onready var decoy_check_button = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/MarginContainer/MarginContainer/MarginContainer/FlowContainer/DecoyCheckButton
@onready var decoy_button = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/MarginContainer/MarginContainer/MarginContainer/FlowContainer/DecoyButton
@onready var decoy_line_2d = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/Line2D



@onready var picker_default_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/DefaultNoteBgColor/PickerDefaultMateColor
@onready var picker_outline_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/NoteBGOutlineColor/PickerHoweredMateColor
@onready var picker_default_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/DefaultTextColor/PickerDefaultTextColor
@onready var picker_line_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/LineColor/PickerLineColor

@onready var picker_textedit_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/DefaultNoteBgColor2/PickerDefaultMateColor
@onready var picker_textedit_outline_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/NoteBGOutlineColor2/PickerHoweredMateColor
@onready var picker_textedit_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/DefaultTextColor2/PickerDefaultTextColor
@onready var picker_textedit_placeholder_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/NoteBodyColorPickersList/PlaceholderTextColor3/PickerDefaultTextColor

@onready var picker_button_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/DefaultMateColor/PickerDefaultMateColor
@onready var picker_button_outline_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/DefaultOutlineColor/PickerDefaultOutlineColor
@onready var picker_button_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/DefaultTextColor/PickerDefaultTextColor
@onready var picker_howered_button_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/HoweredMateColor/PickerHoweredMateColor
@onready var picker_howered_button_outline_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/HoweredOutlineColor/PickerHoweredOutlineColor
@onready var picker_howered_button_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/HoweredTextColor/PickerDefaultTextColor
@onready var picker_in_use_button_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/InUseMateColor/PickerInUseMateColor
@onready var picker_in_use_button_outline_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/InUseOutlineColor/PickerInUseOutlineColor
@onready var picker_in_use_button_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/InUseTextColor/PickerInactiveTextColor
#@onready var picker_default_mate_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/DisabledMateColor/PickerDefaultMateColor
#@onready var picker_default_outline_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/DisabledOutlineColor/PickerDefaultOutlineColor
#@onready var picker_inactive_text_color = $CanvasLayer/Control/VBoxContainer2/StyleTabContainer/StyleExampleContainer/VBoxContainer/ThemePreview/VBoxContainer/HBoxContainer/ButtonColorPickersList2/DisabledTextColor/PickerInactiveTextColor
const DEFAULTTHEME = preload("res://scenes/defaulttheme.tres")
#var curcolordic := {
#}
var curcolordic := {}
# Called when the node enters the scene tree for the first time.
func _ready():
	#for chlds in get_tree().get_nodes_in_group("themegrp"):
	#	apply_thm_override(chlds)
	#if Gset.curcolordic == Gset.colorblackdic:
	#	theme_choose_button.selected = 0
	#	open_user_theme_settings.visible = false
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

func apply_thm_override(node):
	if FileAccess.file_exists(current_user_theme_path):
		var file = FileAccess.open(current_user_theme_path,FileAccess.READ)
		var tempthmdic = file.get_var(true) as Dictionary
		#if not tempthmdic.is_empty():
		curcolordic = tempthmdic
	else:
		curcolordic = Gset.colorblackdic
	if node is Button or CheckButton:
		node.add_theme_color_override("font_color",curcolordic["buttontxtcol"])
		node.add_theme_color_override("font_hover_color",curcolordic["buttonhowtxtcol"])
		node.add_theme_color_override("font_hover_pressed_color",curcolordic["buttonprstxtcol"])
		node.add_theme_color_override("font_pressed_color",curcolordic["buttonprstxtcol"])
		node.add_theme_color_override("font_disabled_color",Color(0.875,0.875,0.875,0.5))
		var nrmstlb = node.get_theme_stylebox("normal").duplicate()
		nrmstlb.set("bg_color", curcolordic["buttonbgcol"])
		nrmstlb.set("border_color", curcolordic["buttonoutlncol"])
		node.add_theme_stylebox_override("normal", nrmstlb)
		var howstlb = node.get_theme_stylebox("hover").duplicate()
		howstlb.set("bg_color", curcolordic["buttonhowbgcol"])
		howstlb.set("border_color", curcolordic["buttonhowoutlncol"])
		node.add_theme_stylebox_override("hover", howstlb)
		var prsstlb = node.get_theme_stylebox("pressed").duplicate()
		prsstlb.set("bg_color", curcolordic["buttonprsbgcol"])
		prsstlb.set("border_color", curcolordic["buttonprsoutlncol"])
		node.add_theme_stylebox_override("pressed", prsstlb)
	elif node is Label:
		node.add_theme_color_override("font_color",curcolordic["deftextcol"])
	elif node is Panel:
		var panstlb = node.get_theme_stylebox("panel").duplicate()
		panstlb.set("bg_color", curcolordic["notebgcol"])
		panstlb.set("border_color", curcolordic["noteoutlinecol"])
		node.add_theme_stylebox_override("panel", panstlb)
	elif node is TextEdit:
		node.add_theme_color_override("font_color",curcolordic["texteditdeftextcol"])
		node.add_theme_color_override("font_placeholder_color",curcolordic["texteditplhldrtextcol"])
		var tedstlb = node.get_theme_stylebox("normal").duplicate()
		tedstlb.set("bg_color", curcolordic["texteditbgcol"])
		tedstlb.set("border_color", curcolordic["texteditoutlinecol"])
		node.add_theme_stylebox_override("normal", tedstlb)
	elif node is Line2D:
		node.default_color = curcolordic["lineconcol"]


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


func _on_cancel_theme_edit_pressed():
	save_theme(Gset.curcolordic)
	style_tab_container.current_tab = 0

func set_pickers_theme_via_dic(inserteddic:Dictionary):
	picker_default_mate_color.color = inserteddic["notebgcol"]
	picker_outline_mate_color.color = inserteddic["noteoutlinecol"]
	picker_default_text_color.color = inserteddic["deftextcol"]
	picker_line_color.color = inserteddic["lineconcol"]
	picker_textedit_mate_color.color = inserteddic["texteditbgcol"]
	picker_textedit_outline_color.color = inserteddic["texteditoutlinecol"]
	picker_textedit_text_color.color = inserteddic["texteditdeftextcol"]
	picker_textedit_placeholder_text_color.color = inserteddic["texteditplhldrtextcol"]
	picker_button_mate_color.color = inserteddic["buttonbgcol"]
	picker_button_outline_color.color = inserteddic["buttonoutlncol"]
	picker_button_text_color.color = inserteddic["buttontxtcol"]
	picker_howered_button_mate_color.color = inserteddic["buttonhowbgcol"]
	picker_howered_button_outline_color.color = inserteddic["buttonhowoutlncol"]
	picker_howered_button_text_color.color = inserteddic["buttonhowtxtcol"]
	picker_in_use_button_mate_color.color = inserteddic["buttonprsbgcol"]
	picker_in_use_button_outline_color.color = inserteddic["buttonprsoutlncol"]
	picker_in_use_button_text_color.color = inserteddic["buttonprstxtcol"]

func get_theme_dic_from_pickers():
	var outputdic := {
	notebgcol = picker_default_mate_color.color,
	noteoutlinecol = picker_outline_mate_color.color,
	deftextcol = picker_default_text_color.color,
	lineconcol = picker_line_color.color,
	texteditbgcol = picker_textedit_mate_color.color,
	texteditoutlinecol = picker_textedit_outline_color.color,
	texteditdeftextcol = picker_textedit_text_color.color,
	texteditplhldrtextcol = picker_textedit_placeholder_text_color.color,
	buttonbgcol = picker_button_mate_color.color,
	buttonoutlncol = picker_button_outline_color.color,
	buttontxtcol = picker_button_text_color.color,
	buttonhowbgcol = picker_howered_button_mate_color.color,
	buttonhowoutlncol = picker_howered_button_outline_color.color,
	buttonhowtxtcol = picker_howered_button_text_color.color,
	buttonprsbgcol = picker_in_use_button_mate_color.color,
	buttonprsoutlncol = picker_in_use_button_outline_color.color,
	buttonprstxtcol = picker_in_use_button_text_color.color
	}
	return outputdic

func save_theme(insdiic: Dictionary):
	var file = FileAccess.open(current_user_theme_path,FileAccess.WRITE)
	file.store_var(insdiic,true)
	file.close()
	#Gset.set_theme_data(insdiic)
	#for chlds in get_tree().get_nodes_in_group("themegrp"):
	#	chlds.set_theme(Gset.currenttheme)


func _on_reset_theme_edit_pressed():
	Gset.curcolordic = Gset.colorblackdic
	save_theme(Gset.curcolordic)
	set_pickers_theme_via_dic(Gset.curcolordic)
	#for chlds in get_tree().get_nodes_in_group("themegrp"):
	#	apply_thm_override(chlds)


func _on_picker_default_mate_color_color_changed(color):
	var nstlb = decoy_panel.get_theme_stylebox("panel").duplicate()
	nstlb.set("bg_color", color)
	decoy_panel.add_theme_stylebox_override("panel", nstlb)
	Gset.curcolordic["notebgcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_outline_color_color_changed(color):
	var nstlb = decoy_panel.get_theme_stylebox("panel").duplicate()
	nstlb.set("border_color", color)
	decoy_panel.add_theme_stylebox_override("panel", nstlb)
	Gset.curcolordic["noteoutlinecol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_default_text_color_color_changed(color):
	decoy_label.add_theme_color_override("font_color", color)
	Gset.curcolordic["deftextcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_line_color_color_changed(color):
	decoy_line_2d.default_color = color
	Gset.curcolordic["lineconcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_textedit_mate_color_color_changed(color):
	var nstlb = decoy_text_edit.get_theme_stylebox("normal").duplicate()
	nstlb.set("bg_color", color)
	decoy_text_edit.add_theme_stylebox_override("normal", nstlb)
	Gset.curcolordic["texteditbgcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_textedit_outline_color_color_changed(color):
	var nstlb = decoy_text_edit.get_theme_stylebox("normal").duplicate()
	nstlb.set("border_color", color)
	decoy_text_edit.add_theme_stylebox_override("normal", nstlb)
	Gset.curcolordic["texteditoutlinecol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_textedit_text_color_color_changed(color):
	decoy_text_edit.add_theme_color_override("font_color", color)
	Gset.curcolordic["texteditdeftextcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_textedit_placeholder_text_color_color_changed(color):
	decoy_text_edit.add_theme_color_override("font_placeholder_color", color)
	Gset.curcolordic["texteditplhldrtextcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_button_mate_color_color_changed(color):
	var nstlb = decoy_button.get_theme_stylebox("normal").duplicate()
	nstlb.set("bg_color", color)
	decoy_button.add_theme_stylebox_override("normal", nstlb)
	var nstlchb = decoy_check_button.get_theme_stylebox("normal").duplicate()
	nstlchb.set("bg_color", color)
	decoy_check_button.add_theme_stylebox_override("normal", nstlchb)
	Gset.curcolordic["buttonbgcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_button_outline_color_color_changed(color):
	var nstlb = decoy_button.get_theme_stylebox("normal").duplicate()
	nstlb.set("border_color", color)
	decoy_button.add_theme_stylebox_override("normal", nstlb)
	var nstlchb = decoy_check_button.get_theme_stylebox("normal").duplicate()
	nstlchb.set("border_color", color)
	decoy_check_button.add_theme_stylebox_override("normal", nstlchb)
	Gset.curcolordic["buttonoutlncol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_button_text_color_color_changed(color):
	decoy_button.add_theme_color_override("font_color", color)
	decoy_text_edit.add_theme_color_override("font_color", color)
	Gset.curcolordic["buttontxtcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_button_howered_mate_color_color_changed(color):
	var nstlb = decoy_button.get_theme_stylebox("hover").duplicate()
	nstlb.set("bg_color", color)
	decoy_button.add_theme_stylebox_override("hover", nstlb)
	var nstlchb = decoy_check_button.get_theme_stylebox("hover").duplicate()
	nstlchb.set("bg_color", color)
	decoy_check_button.add_theme_stylebox_override("hover", nstlchb)
	Gset.curcolordic["buttonhowbgcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_button_howered_outline_color_color_changed(color):
	var nstlb = decoy_button.get_theme_stylebox("hover").duplicate()
	nstlb.set("border_color", color)
	decoy_button.add_theme_stylebox_override("hover", nstlb)
	var nstlchb = decoy_check_button.get_theme_stylebox("hover").duplicate()
	nstlchb.set("border_color", color)
	decoy_check_button.add_theme_stylebox_override("hover", nstlchb)
	Gset.curcolordic["buttonhowoutlncol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_button_howered_text_color_color_changed(color):
	decoy_button.add_theme_color_override("font_hover_color", color)
	decoy_text_edit.add_theme_color_override("font_hover_color", color)
	Gset.curcolordic["buttonhowtxtcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_pressed_button_mate_color_color_changed(color):
	var nstlb = decoy_button.get_theme_stylebox("pressed").duplicate()
	nstlb.set("bg_color", color)
	decoy_button.add_theme_stylebox_override("pressed", nstlb)
	var nstlchb = decoy_check_button.get_theme_stylebox("pressed").duplicate()
	nstlchb.set("bg_color", color)
	decoy_check_button.add_theme_stylebox_override("pressed", nstlchb)
	Gset.curcolordic["buttonprsbgcol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_pressed_button_outline_color_color_changed(color):
	var nstlb = decoy_button.get_theme_stylebox("pressed").duplicate()
	nstlb.set("border_color", color)
	decoy_button.add_theme_stylebox_override("pressed", nstlb)
	var nstlchb = decoy_check_button.get_theme_stylebox("pressed").duplicate()
	nstlchb.set("border_color", color)
	decoy_check_button.add_theme_stylebox_override("pressed", nstlchb)
	Gset.curcolordic["buttonprsoutlncol"] = color
	save_theme(Gset.curcolordic)


func _on_picker_pressed_button_text_color_color_changed(color):
	decoy_button.add_theme_color_override("font_pressed_color", color)
	decoy_text_edit.add_theme_color_override("font_pressed_color", color)
	decoy_button.add_theme_color_override("font_hover_pressed_color", color)
	decoy_text_edit.add_theme_color_override("font_hover_pressed_color", color)
	Gset.curcolordic["buttonprstxtcol"] = color
	save_theme(Gset.curcolordic)
