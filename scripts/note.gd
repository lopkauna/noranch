extends Node2D

@onready var note_basis = $"../.."
@onready var camera_2d = $"../../Camera2D"

@onready var body = $body
@onready var tab_container = $body/VBoxContainer/HBoxContainer/TabContainer
@onready var fitin = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/fitin
@onready var text = $body/VBoxContainer/HBoxContainer/TabContainer/ScrollContainer/NoteContent/Text
@onready var scroll_container = $body/VBoxContainer/HBoxContainer/TabContainer/ScrollContainer
@onready var file_dialog = $FileDialog
@onready var remove_image = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/HBoxContainer3/RemoveImage
@onready var texture_rect = $body/VBoxContainer/HBoxContainer/TabContainer/ScrollContainer/NoteContent/PanelContainer/TextureRect
@onready var clear_image_text = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/HBoxContainer/ClearImageText
@onready var entr_image_text = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/HBoxContainer/ImageText
@onready var image_text = $body/VBoxContainer/HBoxContainer/TabContainer/ScrollContainer/NoteContent/PanelContainer/ImageText

@onready var options_tab = $body/VBoxContainer/MarginContainer/HBoxContainer/OptionsTab
@onready var move_note_button = $body/VBoxContainer/MarginContainer/HBoxContainer/MoveNoteButton
@onready var back_button = $body/VBoxContainer/MarginContainer/Back

@onready var resize_note_button = $body/VBoxContainer/HBoxContainer/MarginContainer2/ResizeNoteButton


@onready var connect_to = $body/VBoxContainer/HBoxContainer/MarginContainer/ConnectTo
@onready var add_note = $"body/VBoxContainer/HBoxContainer/MarginContainer2/Add Note"
@onready var line_2d = $body/VBoxContainer/HBoxContainer/MarginContainer/ConnectTo/Line2D
@onready var popup_menu = $body/PopupMenu
@onready var current_font_size = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/HBoxContainer2/CurrentFontSize
@onready var image_tint = $body/VBoxContainer/HBoxContainer/TabContainer/ScrollContainer/NoteContent/PanelContainer/ImageTint
@onready var image_tint_button = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/HBoxContainer2/ImageTintButton
@onready var label = $body/VBoxContainer/HBoxContainer/TabContainer/ScrollContainer/NoteContent/Text/Label
@onready var light_up = $body/LightUp
@onready var h_flow_container = $body/VBoxContainer/TextBasedMargin/TagsContainer/HFlowContainer
@onready var add_new_tag_button = $body/VBoxContainer/HBoxContainer/TabContainer/TagsSettings/AddNewTagButton
@onready var add_tag_dialog = $AddTagDialog
@onready var add_tag_dialog_text = $AddTagDialog/TagDialogText
@onready var tags_properts = $body/VBoxContainer/HBoxContainer/TabContainer/TagsSettings/TagsProperts
@onready var show_tags = $body/VBoxContainer/HBoxContainer/TabContainer/Settings/ShowTags
@onready var tags_container = $body/VBoxContainer/TextBasedMargin/TagsContainer
@onready var tags_settings = $body/VBoxContainer/HBoxContainer/TabContainer/TagsSettings
@onready var settings_tab = $body/VBoxContainer/HBoxContainer/TabContainer/Settings
@onready var text_based_margin = $body/VBoxContainer/TextBasedMargin



var deltreshold = 0

var is_connecting_to = false
var scrlison = false
var vsbl = 0

var islightup = false

var isrsng = false
var rsoffset = Vector2(0,0)

var ismvng = false
var mvoffset = Vector2(0,0)
var oldname = ""

var tags_array : Array = []
var temp_tags_array : Array = []
var tagsisvisbl = true

var cursize = Vector2(0,0)

func _ready():
	#tagsisvisbl = text_based_margin.visible
	tab_container.self_modulate.a = 0
	light_up.global_position = tab_container.get_global_rect().position - Vector2(4,4)
	light_up.size = tab_container.get_global_rect().size + Vector2(8,8)
	cursize = tab_container.get_global_rect().size
	image_tint_button.button_pressed = image_tint.visible
	
	

func _process(delta):
	if camera_2d.global_position.distance_to(global_position + Vector2(tab_container.get_global_rect().size.x*0.5+22,tab_container.get_global_rect().size.y*0.5+4)) > (get_viewport_rect().size.x + get_viewport_rect().size.y) * (1.35-camera_2d.zoom.x*0.25):
		hide()
		line_2d.set_process(false)
		tags_container.set_process(false)
		return
	else:
		line_2d.set_process(true)
		tags_container.set_process(true)
		show()
	tags_settings.custom_minimum_size.y = scroll_container.size.y
	settings_tab.custom_minimum_size.y = scroll_container.size.y
	if add_tag_dialog.visible == true:
		note_basis.isnotedialog = true
	
	match tab_container.current_tab:
		0:
			#print(text.get_focus_owner())
			if text.has_focus():
				if Input.is_action_just_pressed("ui_cancel"):
					text.release_focus()
				if Input.is_action_just_pressed("crnextnoteshrtcut"):
					create_next_note()
			if temp_tags_array != tags_array:
				tags_array.clear()
				tags_array.append_array(temp_tags_array)
				update_tags_apost()
			#else:
			#	for i in temp_tags_array.size():
			#		if temp_tags_array[i] != tags_array[i]:
			#			tags_array = temp_tags_array
			#			update_tags_apost()
		2:
			if temp_tags_array != tags_array:
				tags_array.clear()
				tags_array.append_array(temp_tags_array)
				update_tags_optionlist()
		
	light_up.global_position = tab_container.get_global_rect().position - Vector2(4,4)
	light_up.size = tab_container.get_global_rect().size + Vector2(8,8)
	if islightup == true:
		light_up.self_modulate.a = move_toward(light_up.self_modulate.a,0.164,delta*10)
	else:
		light_up.self_modulate.a = move_toward(light_up.self_modulate.a,0.0,delta*10)
	cursize = tab_container.get_global_rect().size
	if text.text == "":
		label.visible = true
	else:
		label.visible = false
	current_font_size.text = "Title Size = " + str(image_text.get_theme_font_size("font_size"))
	if is_connecting_to == true:
		note_basis.somenotehovered = true
		if not (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5):
			Gset.curnotehold = null
			is_connecting_to = false
			
	if isrsng == true:
		note_basis.somenotehovered = true
		vsbl = 0
		tab_container.custom_minimum_size.x = clampf(get_global_mouse_position().x - tab_container.global_position.x + rsoffset.x,160,4000)#) - tab_container.global_position
		tab_container.custom_minimum_size.y = clampf(get_global_mouse_position().y - tab_container.global_position.y + rsoffset.y,92,2000)#) - tab_container.global_position
		if not (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5):
			isrsng = false
	if ismvng == true:
		note_basis.somenotehovered = true
		self.global_position = get_global_mouse_position() + mvoffset
		if not (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5):
			ismvng = false
	scroll_container.get_v_scroll_bar().size.x = 0
	if image_text.text == "":
		image_text.visible = false
	else:
		image_text.visible = true
	if texture_rect.texture == null:
		image_tint_button.self_modulate.a = 0
		scroll_container.custom_minimum_size.y = 80
		remove_image.visible = false
	else:
		image_tint_button.self_modulate.a = 1
		scroll_container.custom_minimum_size.y = texture_rect.get_global_rect().size.y
		remove_image.visible = true
	vsbl = move_toward(vsbl,0,delta*10)
	deltreshold = move_toward(deltreshold,0,delta*10)
	if vsbl <= 0:
		if is_connecting_to == false:
			connect_to.self_modulate.a = 0
		add_note.modulate.a = 0
		resize_note_button.modulate.a = 0
		move_note_button.visible = false
		options_tab.visible = false
		back_button.visible = false
		tab_container.current_tab = 0
		scroll_container.scroll_vertical = 0
		if scrlison == true:
			scroll_container.vertical_scroll_mode = 3
		islightup = false
		if tagsisvisbl == true:
			text_based_margin.modulate.a = 1
		else:
			text_based_margin.modulate.a = 0
		if texture_rect.texture == null:
			text.modulate.a = 1
		else:
			if text.text.strip_edges(true,true) == "":
				text.modulate.a = 0
			else:
				text.modulate.a = 1
		if Gset.curnotehold != null:
			if (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5) and Gset.curnotehold != line_2d and note_basis.somenotehovered == false:
				var nl = Gset.curnotehold
				nl.set_targetnote(null)
		if Input.get_mouse_button_mask() == 1 and text.has_focus():
			text.release_focus()
	else:
		text.modulate.a = 1
		#text.visible = true
		text_based_margin.modulate.a = 1
		note_basis.somenotehovered = true
		islightup = false
		if Gset.curnotehold != null:
			if (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5) and Gset.curnotehold != line_2d:
				var nl = Gset.curnotehold
				nl.set_targetnote(self)
				if line_2d.targetnode == nl.get_papa_note():
					line_2d.set_targetnote(null)
				islightup = true
		else:
			if Input.get_mouse_button_mask() == 2:
				popup_menu.popup(Rect2(get_viewport().get_mouse_position().x,get_viewport().get_mouse_position().y,popup_menu.size.x,popup_menu.size.y))
			if Input.is_action_just_pressed("movenotes"):
				if deltreshold > 0:
					self.queue_free()
				else:
					deltreshold = 0.284
			connect_to.self_modulate.a = 1
			add_note.modulate.a = 1
			resize_note_button.modulate.a = 1
			if tab_container.current_tab == 0:
				move_note_button.visible = true
				options_tab.visible = true
				back_button.visible = false
			else:
				move_note_button.visible = false
				options_tab.visible = false
				back_button.visible = true
			if scrlison == true:
				scroll_container.vertical_scroll_mode = 1
				note_basis.canzoom = false
	if get_global_mouse_position().x == clampf(get_global_mouse_position().x,body.get_global_rect().position.x,body.get_global_rect().end.x):#get_global_rect().position.x <= get_global_mouse_position().x and get_global_rect().end.x >= get_global_mouse_position().x:
		if get_global_mouse_position().y == clampf(get_global_mouse_position().y,body.get_global_rect().position.y,body.get_global_rect().end.y):#get_global_rect().position.y <= get_global_mouse_position().y and get_global_rect().end.y >= get_global_mouse_position().y:
			vsbl = 0.1
	if scrlison == false:
		scroll_container.vertical_scroll_mode = 0
	

func get_tab_rect():
	return tab_container.get_global_rect()

func _on_fitin_toggled(toggled_on):
	scrlison = toggled_on
	

func _on_delete_pressed():
	queue_free()


func _on_load_image_pressed():
	file_dialog.popup()


func set_textimage(textr):
	texture_rect.texture = textr


func _on_file_dialog_file_selected(path):
	var img = Image.new()
	img.load(path)
	var imgtxtr = ImageTexture.new()
	imgtxtr.set_image(img)
	set_textimage(imgtxtr)


func _on_remove_image_pressed():
	texture_rect.texture = null


func _on_image_text_text_changed(new_text):
	var nstr : String = str(new_text)
	nstr.strip_edges(true,true)
	image_text.text = nstr


func _on_clear_image_text_pressed():
	entr_image_text.clear()


func _on_move_note_button_button_down():
	ismvng = true
	mvoffset = self.global_position - get_global_mouse_position()


func _on_move_note_button_button_up():
	ismvng = false


func _on_text_focus_entered():
	note_basis.isnotedialog = true
	#note_basis.canmov = false


func _on_text_focus_exited():
	note_basis.isnotedialog = false
	#note_basis.canmov = true


func _on_connect_to_button_down():
	Gset.curnotehold = line_2d
	line_2d.set_targetnote(null)
	is_connecting_to = true
	


func _on_back_pressed():
	tab_container.current_tab = 0


func _on_popup_menu_index_pressed(index):
	match index:
		0:
			queue_free()
		1:
			tab_container.current_tab = 1
		2:
			note_basis.isnotedialog = true
			add_tag_dialog.popup()
		3:
			tab_container.custom_minimum_size = Vector2(320,120)

func _on_resize_note_button_button_down():
	isrsng = true
	rsoffset = resize_note_button.global_position - get_global_mouse_position()


func _on_resize_note_button_button_up():
	isrsng = false


func _on_font_size_smaller_pressed():
	image_text.add_theme_font_size_override("font_size",image_text.get_theme_font_size("font_size")-1)


func _on_font_size_bigger_pressed():
	image_text.add_theme_font_size_override("font_size",image_text.get_theme_font_size("font_size")+1)


func reach_targetnode():
	return self

func lightupnote():
	islightup = true

func pass_targetnode(pssin):
	line_2d.set_targetnote(pssin)

func get_note_center_pos():
	var centpos = global_position + Vector2(tab_container.get_global_rect().size.x*0.5+22,tab_container.get_global_rect().size.y*0.5+4)
	return centpos

func _on_add_note_pressed():
	create_next_note()

func create_next_note():
	var nres = load("res://scenes/note.tscn")
	var nnote = nres.instantiate()
	nnote.global_position = global_position + Vector2(tab_container.get_global_rect().size.x+40,tab_container.get_global_rect().size.y*0.5-60)
	get_parent().add_child(nnote)
	nnote.pass_targetnode(self)
	nnote.text.grab_focus()
	note_basis.repos_cam(nnote.global_position + Vector2(160,64))

func _on_options_tab_pressed():
	tab_container.current_tab = 1


func _on_image_tint_button_toggled(toggled_on):
	image_tint.visible = toggled_on


func _on_def_size_button_pressed():
	tab_container.custom_minimum_size = Vector2(320,120)


func get_note_data():
	var nbut : Node2D
	if line_2d.targetnode != null:
		if not line_2d.targetnode.is_queued_for_deletion():
			nbut = line_2d.targetnode
		else:
			nbut = null
	else:
		nbut = null
	var contsaving = ""
	if nbut != null:
		contsaving = nbut.name
	var ndic : Dictionary = {
		"oldname": self.name,
		"posx": global_position.x,
		"posy": global_position.y,
		"sizex": tab_container.custom_minimum_size.x,
		"sizey": tab_container.custom_minimum_size.y,
		"image": texture_rect.texture,
		"imagetint": image_tint.visible,
		"titletext": image_text.text,
		"titlesize": image_text.get_theme_font_size("font_size"),
		"isscrolling": scrlison,#clampi(scroll_container.vertical_scroll_mode,0,1),
		"linetarget": contsaving,
		"text": text.text,
		"tagsarr": tags_array,
		"tagsvisible": tagsisvisbl
	}
	return ndic

func set_note_data(givendic):
	oldname = givendic["oldname"]
	global_position = Vector2(givendic["posx"],givendic["posy"])
	tab_container.custom_minimum_size = Vector2(givendic["sizex"],givendic["sizey"])
	texture_rect.texture = givendic["image"]
	image_tint.visible = givendic["imagetint"]
	image_text.text = givendic["titletext"]
	image_text.add_theme_font_size_override("font_size",givendic["titlesize"])
	scrlison = givendic["isscrolling"]
	#scroll_container.vertical_scroll_mode = givendic["isscrolling"]
	var contsaving = givendic["linetarget"]
	for chlds in get_parent().get_children():
		if chlds.oldname == contsaving:
			line_2d.targetnode = chlds.reach_targetnode()
	text.text = givendic["text"]
	temp_tags_array = givendic["tagsarr"]
	tagsisvisbl = givendic["tagsvisible"]


func _on_add_tag_dialog_confirmed():
	note_basis.isnotedialog = false
	#note_basis.canmov = true
	if add_tag_dialog_text.text.strip_edges(true,true) != "":
		if not temp_tags_array.has(add_tag_dialog_text.text.strip_edges(true,true)):
			temp_tags_array.insert(0,add_tag_dialog_text.text.strip_edges(true,true))
	add_tag_dialog_text.text = ""
	if tab_container.current_tab == 0:
		update_tags_apost()
	if tab_container.current_tab == 2:
		update_tags_optionlist()

func _on_tags_click_pressed():
	tab_container.current_tab = 2

func tags_rewritten(ntxt,idtxt):
	temp_tags_array[idtxt] = ntxt
	#for i in tags_array.size():
	#	tags_properts.get_children()[i]

func tag_remove(idtxt):
	temp_tags_array.erase(temp_tags_array[idtxt])

func update_tags_apost():
	if h_flow_container.get_child_count() > 0:
		for chlds in h_flow_container.get_children():
			chlds.queue_free()
	tags_array.reverse()
	for i in tags_array.size():
		var nlab = Label.new()
		h_flow_container.add_child(nlab)
		nlab.text = "#" + tags_array[i]

func update_tags_optionlist():
	if tags_properts.get_child_count() > 0:
		for chlds in tags_properts.get_children():
			chlds.queue_free()
	for i in tags_array.size():
		var nhbox = HBoxContainer.new()
		tags_properts.add_child(nhbox)
		nhbox.add_theme_constant_override("separation",0)
		var nlab = LineEdit.new()
		nhbox.add_child(nlab)
		nlab.text = tags_array[i]
		nlab.connect("text_changed",Callable(self,"tags_rewritten").bind(i))
		nlab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var nbut = Button.new()
		nhbox.add_child(nbut)
		nbut.text = " X "
		nbut.connect("pressed",Callable(self,"tag_remove").bind(i))

func _on_tab_container_tab_changed(tab):
	match tab:
		0:
			update_tags_apost()
		1:
			fitin.button_pressed = scrlison
			show_tags.button_pressed = tagsisvisbl
		2:
			update_tags_optionlist()

func check_tag(tagname):
	if tags_array.has(tagname):
		return self
	else:
		return null


func _on_add_tag_dialog_canceled():
	note_basis.isnotedialog = false


func _on_show_tags_toggled(toggled_on):
	tagsisvisbl = toggled_on


func _on_go_tags_settings_button_pressed():
	tab_container.current_tab = 2


func _on_add_new_tag_button_pressed():
	note_basis.isnotedialog = true
	add_tag_dialog.popup()
