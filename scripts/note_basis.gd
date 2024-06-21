extends Node2D

@onready var camera_2d = $Camera2D
@onready var load_dialog = $CanvasLayer/LoadDialog
@onready var save_dialog = $CanvasLayer/SaveDialog
@onready var color_rect = $ParallaxBackground/ColorRect
@onready var color_rect_2 = $ParallaxBackground/ColorRect2
@onready var popup_menu = $PopupMenu
@onready var notes_table = $"Notes Table"
@onready var greetings = $Greetings
@onready var tag_finder_panel = $CanvasLayer/Control/HBoxContainer2/TagFinderPanel
@onready var search = $CanvasLayer/Control/HBoxContainer2/Search
@onready var tag_search_line_edit = $CanvasLayer/Control/HBoxContainer2/TagFinderPanel/Control/VBoxContainer/Panel/TagSearchLineEdit
@onready var match_count = $CanvasLayer/Control/HBoxContainer2/TagFinderPanel/Control/VBoxContainer/Panel/MatchCount
@onready var find_tag_control = $CanvasLayer/Control/HBoxContainer2/TagFinderPanel/Control

@onready var selection = $selection


const last_unsaved_session_path = "user://lastunsavedsession.data"
const last_sessions_array_path = "user://lastsessionsarray.data"

var tagsearcharr : Array = []
var currnotefocus = null
var mmov = Vector2(0,0)
var zmsens = 0.2
var accel = 4
var canmov = true
var canzoom = true
var somenotehovered = false
var fastmovecharge = 0
var inclick = false
var txtlock = false
var isnotedialog = false

var isselectionon = false
var selectionstart = Vector2(0,0)
var selectionarr : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	search.button_pressed = tag_finder_panel.visible
	if Gset.BIFS == true:
		load_dialog.use_native_dialog = false
		save_dialog.use_native_dialog = false
	else:
		load_dialog.use_native_dialog = true
		save_dialog.use_native_dialog = true
	if Gset.temp_dic.size()>0: #!= null:
		loc_load()
	color_rect.visible = Gset.GridBG
	color_rect_2.visible = Gset.AnimatedBG
	greetings.visible = -clamp(notes_table.get_child_count()-1,-1,0)
	greetings.text = "Create your first note with [" + "Right Mouse Button" + "
or just Drag and Drop file here" #InputMap.action_get_events(action)[0].as_text()
	load_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	save_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	get_tree().get_root().files_dropped.connect(on_files_drop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if search.button_pressed == true:
		if get_viewport().get_mouse_position().x == clampf(get_viewport().get_mouse_position().x,find_tag_control.get_global_rect().position.x,find_tag_control.get_global_rect().end.x):#get_global_rect().position.x <= get_global_mouse_position().x and get_global_rect().end.x >= get_global_mouse_position().x:
			if get_viewport().get_mouse_position().y == clampf(get_viewport().get_mouse_position().y,find_tag_control.get_global_rect().position.y,find_tag_control.get_global_rect().end.y):#get_global_rect().position.y <= get_global_mouse_position().y and get_global_rect().end.y >= get_global_mouse_position().y:
				canmov = false
			else:
				#if Input.get_mouse_button_mask() == 1:
					#tag_search_line_edit.emit_signal("gui_input",InputMap.)
				if txtlock == true:
					canmov = false
				else:
					if isnotedialog == false:
						canmov = true
					else:
						canmov = false
		else:
			#if Input.get_mouse_button_mask() == 1:
			#		tag_search_line_edit.emit_signal("gui_input",Input.is_action_just_pressed("ui_cancel"))
			if txtlock == true:
				canmov = false
			else:
				if isnotedialog == false:
					canmov = true
				else:
					canmov = false
	else:
		txtlock = false
		if isnotedialog == false:
			canmov = true
		else:
			canmov = false
	if Input.get_mouse_button_mask() == 2 and somenotehovered == false:
		if not selectionarr.is_empty():
			if popup_menu.item_count < 4:
				popup_menu.add_item("Delete Notes",3)
			popup_menu.size.y = 115
		else:
			if popup_menu.item_count > 3:
				popup_menu.remove_item(3)
			popup_menu.size.y = 89
		popup_menu.popup(Rect2(get_viewport().get_mouse_position().x,get_viewport().get_mouse_position().y,popup_menu.size.x,popup_menu.size.y))
	if somenotehovered == false and Input.get_mouse_button_mask() == 1 and isselectionon == false:
		if popup_menu.visible == false:
			selectionarr = []
			isselectionon = true
			selectionstart = get_global_mouse_position()
	if Input.get_mouse_button_mask() == 0:
		isselectionon = false
	if isselectionon == true:
		selection.visible = true
		if selectionstart.x < get_global_mouse_position().x:
			if selectionstart.y < get_global_mouse_position().y:
				selection.global_position = selectionstart
				selection.size = get_global_mouse_position()-selectionstart
			else:
				selection.global_position = Vector2(selectionstart.x,get_global_mouse_position().y)
				selection.size = Vector2(get_global_mouse_position().x-selectionstart.x,selectionstart.y-get_global_mouse_position().y)
		else:
			if selectionstart.y < get_global_mouse_position().y:
				selection.global_position = Vector2(get_global_mouse_position().x,selectionstart.y)
				selection.size = Vector2(selectionstart.x-get_global_mouse_position().x,get_global_mouse_position().y-selectionstart.y)
			else:
				selection.global_position = get_global_mouse_position()
				selection.size = selectionstart-get_global_mouse_position()
		for chlds in notes_table.get_children():
			if chlds.get_note_center_pos().y == clampf(chlds.get_note_center_pos().y,selection.global_position.y,selection.global_position.y+selection.size.y) and chlds.get_note_center_pos().x == clampf(chlds.get_note_center_pos().x,selection.global_position.x,selection.global_position.x+selection.size.x):# > Vector2(selection.global_position.x,selection.global_position.y-selection.size.y) and chlds.get_note_center_pos() < Vector2(selection.global_position.x-selection.size.x,selection.global_position.y):
				chlds.lightupnote()
	else:
		if selection.visible == true:
			for chlds in notes_table.get_children():
				if chlds.get_note_center_pos().y == clampf(chlds.get_note_center_pos().y,selection.global_position.y,selection.global_position.y+selection.size.y) and chlds.get_note_center_pos().x == clampf(chlds.get_note_center_pos().x,selection.global_position.x,selection.global_position.x+selection.size.x):# > Vector2(selection.global_position.x,selection.global_position.y-selection.size.y) and chlds.get_note_center_pos() < Vector2(selection.global_position.x-selection.size.x,selection.global_position.y):
					if not selectionarr.has(chlds):
						selectionarr.append(chlds)
		selection.visible = false
	if not selectionarr.is_empty():
		for nts in selectionarr:
			nts.lightupnote()
	greetings.visible = -clamp(notes_table.get_child_count()-1,-1,0)
	color_rect.visible = Gset.GridBG
	color_rect_2.visible = Gset.AnimatedBG
	zmsens = clampf(0.2*camera_2d.zoom.x,0.2,0.4)
	var direction = Input.get_vector("left","right","up","down")
	if Input.is_action_just_pressed("delete_note") and not selectionarr.is_empty():
		for nts in selectionarr:
			for chld in notes_table.get_children():
				if nts == chld:
					chld.queue_free()
		selectionarr = []
		#Gset.temp_dic = notes_table.get_children()
		save_unsaved_note()
	if not Input.is_action_pressed("fastmv") or not direction:
		fastmovecharge = 0
	if direction and canmov:
		if Input.is_action_pressed("fastmv"):
			camera_2d.global_position += ((direction*accel) / camera_2d.zoom.x)*clampf(fastmovecharge,2,4)
			fastmovecharge = move_toward(fastmovecharge,4,delta)
		else:
			camera_2d.global_position += (direction / camera_2d.zoom.x) * 2
	if Input.is_action_pressed("movenotes"):
		camera_2d.global_position -= mmov/camera_2d.zoom.x
	if Input.is_action_just_pressed("zoomin") and canzoom == true and camera_2d.zoom.x<4.0: #and Input.is_action_pressed("fastmv"):
		camera_2d.zoom.x += zmsens
		camera_2d.zoom.y += zmsens
		camera_2d.global_position += (get_global_mouse_position()-camera_2d.global_position)*zmsens
	if Input.is_action_just_pressed("zoomout") and canzoom == true and camera_2d.zoom.x>0.5: #and Input.is_action_pressed("fastmv"):
		camera_2d.zoom.x -= zmsens
		camera_2d.zoom.y -= zmsens
		camera_2d.global_position -= (get_global_mouse_position()-camera_2d.global_position)*zmsens
	if Input.is_action_just_pressed("defzoom") and canmov == true:
		camera_2d.zoom.x = 1
		camera_2d.zoom.y = 1
		camera_2d.global_position = Vector2(0,0)
	mmov = Vector2(0,0)
	camera_2d.zoom = clamp(camera_2d.zoom,Vector2(0.4,0.4),Vector2(4.0,4.0))
	#color_rect.material.set_shader_parameter("transperancy",0.4)
	color_rect.material.set_shader_parameter("srensize",DisplayServer.window_get_size())
	color_rect.material.set_shader_parameter("multplr", camera_2d.zoom.x)
	color_rect.material.set_shader_parameter("cmpos", camera_2d.global_position)
	color_rect_2.material.set_shader_parameter("multplr", camera_2d.zoom.x)
	color_rect_2.material.set_shader_parameter("cmpos", camera_2d.global_position)
	canzoom = true
	somenotehovered = false
	#canmov = true
	if load_dialog.visible == true or save_dialog.visible == true:
		canzoom = false


func _input(event):
	if event is InputEventMouseMotion:
		mmov = event.relative
	if event is InputEventMouseButton:
		if Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 2 or Input.get_mouse_button_mask() == 3:
			inclick = true
		if Input.get_mouse_button_mask() == 0:
			if inclick == true:
				save_unsaved_note()
			inclick = false

func repos_cam(npos:Vector2):
	camera_2d.global_position = npos

func _on_main_menu_pressed():
	#loc_save()
	save_unsaved_note()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_load_pressed():
	isnotedialog = true
	load_dialog.popup()
	


func _on_save_pressed():
	isnotedialog = true
	save_dialog.popup()


func _on_popup_menu_index_pressed(index):
	match index:
		0:
			var nres = load("res://scenes/note.tscn")
			var nnote = nres.instantiate()
			nnote.global_position = get_global_mouse_position() - Vector2(168,48)
			notes_table.add_child(nnote)
		1:
			camera_2d.global_position = Vector2(0,0)
		2:
			camera_2d.zoom.x = 1
			camera_2d.zoom.y = 1
		3:
			if not selectionarr.is_empty():
				for nts in selectionarr:
					for chldz in notes_table.get_children():
						if nts == chldz:
							chldz.queue_free()
				selectionarr = []
				save_unsaved_note()


func _on_save_dialog_file_selected(path):
	isnotedialog = false
	var svarr : Array = []
	for chldd in notes_table.get_children():
		svarr.append(chldd.get_note_data())
	var file = FileAccess.open(path,FileAccess.WRITE)
	#var jstring = JSON.stringify(svarr,)
	#file.store_line(jstring)
	file.store_var(svarr,true)
	file.close()
	var ldarr : Array = []
	if FileAccess.file_exists(last_sessions_array_path):
		var sfile = FileAccess.open(last_sessions_array_path,FileAccess.READ)
		var stemp_arr = sfile.get_var(true) as Array
		sfile.close()
		ldarr = stemp_arr
	if not ldarr.has(path):
		ldarr.append(path)
	var tfile = FileAccess.open(last_sessions_array_path,FileAccess.WRITE)
	tfile.store_var(ldarr,true)
	tfile.close()
	Gset.temp_dic = []

func loc_save():
	var svarr : Array = []
	for chldj in notes_table.get_children():
		if chldj != null:
			svarr.append(chldj.get_note_data())
	if svarr.size()>0:
		Gset.temp_dic = svarr
	else:
		Gset.temp_dic = []

func save_unsaved_note():
	var svarr : Array = []
	for chld in notes_table.get_children():
		svarr.append(chld.get_note_data())
	var file = FileAccess.open(last_unsaved_session_path,FileAccess.WRITE)
	file.store_var(svarr,true)
	file.close()
	if svarr.size()>0:
		Gset.temp_dic = svarr
	else:
		Gset.temp_dic = []


func loc_load():
	for chld in notes_table.get_children():
		chld.queue_free()
	var ldarr : Array = []
	ldarr = Gset.temp_dic
	if not ldarr.is_empty():
		for i in ldarr.size():
			var nres = load("res://scenes/note.tscn")
			var nnote = nres.instantiate()
			notes_table.add_child(nnote)
			nnote.oldname = ldarr[i-ldarr.size()]["oldname"]
		for j in ldarr.size():
			notes_table.get_children()[j-ldarr.size()].set_note_data(ldarr[j-ldarr.size()])

func _on_load_dialog_file_selected(path):
	isnotedialog = false
	load_file_by_path(path)

func load_file_by_path(path):
	for chld in notes_table.get_children():
		chld.queue_free()
	if FileAccess.file_exists(path):
		var ldarr : Array = []
		var file = FileAccess.open(path,FileAccess.READ)
		#var temp_jstrng = file.get_var()
		#var temp_arr : Array = JSON.parse_string(temp_jstrng)
		var temp_arr = file.get_var(true) as Array
		file.close()
		ldarr = temp_arr
		ldarr.reverse()
		for i in ldarr.size():
			var nres = load("res://scenes/note.tscn")
			var nnote = nres.instantiate()
			notes_table.add_child(nnote)
			nnote.oldname = ldarr[i-ldarr.size()]["oldname"]
		for j in ldarr.size():
			notes_table.get_children()[j-ldarr.size()].set_note_data(ldarr[j-ldarr.size()])
	var sldarr : Array = []
	if FileAccess.file_exists(last_sessions_array_path):
		var sfile = FileAccess.open(last_sessions_array_path,FileAccess.READ)
		var stemp_arr = sfile.get_var(true) as Array
		sfile.close()
		sldarr = stemp_arr
	if not sldarr.has(path):
		sldarr.append(path)
	var tfile = FileAccess.open(last_sessions_array_path,FileAccess.WRITE)
	tfile.store_var(sldarr,true)
	tfile.close()

func on_files_drop(files):
	var path : String = files[0]
	match path.get_extension():
		"png":
			var img = Image.new()
			img.load(path)
			var imgtxtr = ImageTexture.new()
			imgtxtr.set_image(img)
			var nres = load("res://scenes/note.tscn")
			var nnote = nres.instantiate()
			nnote.global_position = get_global_mouse_position() - Vector2(168,48)
			notes_table.add_child(nnote)
			nnote.set_textimage(imgtxtr)
		"notdat":
			load_file_by_path(path)
	


func _on_clear_pressed():
	for chld in notes_table.get_children():
		chld.queue_free()
	Gset.temp_dic = []


func _on_search_toggled(toggled_on):
	canmov = true
	tag_search_line_edit.text = ""
	tag_finder_panel.visible = toggled_on

func do_tag_search(tagname):
	var nrmtag : String = str(tagname)
	nrmtag.strip_edges(true,true)
	tagsearcharr.clear()
	for chld in notes_table.get_children():
		if chld.check_tag(nrmtag) != null:
			tagsearcharr.append(chld.check_tag(nrmtag))
	match_count.text = "Matches Found: " + str(tagsearcharr.size())
	if tagsearcharr.size()>0:
		currnotefocus = 0
	setpostofocusnote()

func setpostofocusnote():
	if tagsearcharr.size()>0:
		#if tagsearcharr.size()>currnotefocus:
		camera_2d.global_position = tagsearcharr[currnotefocus].get_note_center_pos()

func _on_tag_search_line_edit_text_changed(new_text):
	do_tag_search(new_text)


func _on_prev_pressed():
	canmov = true
	if tagsearcharr.size()>0:
		currnotefocus = clampi(currnotefocus-1,0,tagsearcharr.size()-1)
	setpostofocusnote()


func _on_next_pressed():
	canmov = true
	if tagsearcharr.size()>0:
		currnotefocus = clampi(currnotefocus+1,0,tagsearcharr.size()-1)
	setpostofocusnote()



func _on_tag_search_line_edit_focus_entered():
	txtlock = true


func _on_tag_search_line_edit_focus_exited():
	txtlock = false


func _on_save_dialog_canceled():
	isnotedialog = false


func _on_load_dialog_canceled():
	isnotedialog = false


func _on_load_dialog_confirmed():
	isnotedialog = false


func _on_save_dialog_confirmed():
	isnotedialog = false
