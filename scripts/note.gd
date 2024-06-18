extends Node2D

@onready var note_basis = $"../.."
@onready var body = $body
@onready var tab_container = $body/HBoxContainer/TabContainer
@onready var fitin = $body/HBoxContainer/TabContainer/Settings/fitin
@onready var text = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/Text
@onready var scroll_container = $body/HBoxContainer/TabContainer/ScrollContainer
@onready var file_dialog = $FileDialog
@onready var remove_image = $body/HBoxContainer/TabContainer/Settings/RemoveImage
@onready var texture_rect = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/PanelContainer/TextureRect
@onready var clear_image_text = $body/HBoxContainer/TabContainer/Settings/HBoxContainer/ClearImageText
@onready var entr_image_text = $body/HBoxContainer/TabContainer/Settings/HBoxContainer/ImageText
@onready var image_text = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/PanelContainer/ImageText

@onready var options_tab = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/Text/HBoxMenu/OptionsTab
@onready var move_note_button = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/Text/HBoxMenu/MoveNoteButton
@onready var resize_note_button = $body/HBoxContainer/MarginContainer2/ResizeNoteButton

@onready var connect_to = $body/HBoxContainer/MarginContainer/ConnectTo
@onready var add_note = $"body/HBoxContainer/MarginContainer2/Add Note"
@onready var line_2d = $body/HBoxContainer/MarginContainer/ConnectTo/Line2D
@onready var margin_container = $body/HBoxContainer/MarginContainer
@onready var margin_container_2 = $body/HBoxContainer/MarginContainer2
@onready var popup_menu = $body/PopupMenu
@onready var current_font_size = $body/HBoxContainer/TabContainer/Settings/HBoxContainer2/CurrentFontSize
@onready var image_tint = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/PanelContainer/ImageTint
@onready var image_tint_button = $body/HBoxContainer/TabContainer/Settings/HBoxContainer2/ImageTintButton
@onready var label = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/Text/Label
@onready var light_up = $body/LightUp
@onready var h_flow_container = $body/HBoxContainer/TabContainer/ScrollContainer/NoteContent/TagsContainer/HFlowContainer
@onready var add_tag_dialog = $AddTagDialog
@onready var add_tag_dialog_text = $AddTagDialog/TagDialogText
@onready var tags_properts = $body/HBoxContainer/TabContainer/TagsSettings/TagsProperts


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

var cursize = Vector2(0,0)

func _ready():
	light_up.global_position = tab_container.get_global_rect().position - Vector2(4,4)
	light_up.size = tab_container.get_global_rect().size + Vector2(8,8)
	cursize = tab_container.get_global_rect().size
	image_tint_button.button_pressed = image_tint.visible
	fitin.button_pressed = scroll_container.vertical_scroll_mode


func _process(delta):
	if add_tag_dialog.visible == true:
		note_basis.isnotedialog = true
		#note_basis.canmov = false
	#print(tags_array)
	
	match tab_container.current_tab:
		0:
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
		light_up.self_modulate.a = move_toward(light_up.self_modulate.a,0.164,delta)
	else:
		light_up.self_modulate.a = move_toward(light_up.self_modulate.a,0.0,delta)
	cursize = tab_container.get_global_rect().size
	if text.text == "":
		label.visible = true
	else:
		label.visible = false
	current_font_size.text = "Title Size = " + str(image_text.get_theme_font_size("font_size"))
	if is_connecting_to == true:
		if not (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5):
			is_connecting_to = false
			Gset.curnotehold = null
	if isrsng == true:
		vsbl = 0
		tab_container.custom_minimum_size.x = clampf(get_global_mouse_position().x - tab_container.global_position.x + rsoffset.x,160,4000)#) - tab_container.global_position
		tab_container.custom_minimum_size.y = clampf(get_global_mouse_position().y - tab_container.global_position.y + rsoffset.y,92,2000)#) - tab_container.global_position
		if not (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5):
			isrsng = false
	if ismvng == true:
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
	vsbl = move_toward(vsbl,0,delta)
	deltreshold = move_toward(deltreshold,0,delta)
	if vsbl <= 0:
		if is_connecting_to == false:
			connect_to.self_modulate.a = 0
		add_note.modulate.a = 0
		move_note_button.visible = false
		resize_note_button.visible = false
		options_tab.visible = false
		tab_container.current_tab = 0
		scroll_container.scroll_vertical = 0
		if scrlison == true:
			scroll_container.vertical_scroll_mode = 3
		islightup = false
		if Gset.curnotehold != null:
			if (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5) and Gset.curnotehold != line_2d and note_basis.somenotehovered == false:
				var nl = Gset.curnotehold
				nl.set_targetnode(null)
	else:
		note_basis.somenotehovered = true
		islightup = false
		if Gset.curnotehold != null:
			if (Input.get_mouse_button_mask() == 1 or Input.get_mouse_button_mask() == 5) and Gset.curnotehold != line_2d:
				var nl = Gset.curnotehold
				nl.set_targetnode(self)
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
			move_note_button.visible = true
			resize_note_button.visible = true
			options_tab.visible = true
			if scrlison == true:
				scroll_container.vertical_scroll_mode = 1
				note_basis.canzoom = false
	if get_global_mouse_position().x == clampf(get_global_mouse_position().x,body.get_global_rect().position.x,body.get_global_rect().end.x):#get_global_rect().position.x <= get_global_mouse_position().x and get_global_rect().end.x >= get_global_mouse_position().x:
		if get_global_mouse_position().y == clampf(get_global_mouse_position().y,body.get_global_rect().position.y,body.get_global_rect().end.y):#get_global_rect().position.y <= get_global_mouse_position().y and get_global_rect().end.y >= get_global_mouse_position().y:
			vsbl = 0.1
	if scrlison == false:
		scroll_container.vertical_scroll_mode = 0
	

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


func pass_targetnode(pssin):
	line_2d.set_targetnode(pssin)

func get_note_center_pos():
	var centpos = global_position + Vector2(tab_container.get_global_rect().size.x*0.5+22,tab_container.get_global_rect().size.y*0.5+4)
	return centpos

func _on_add_note_pressed():
	var nres = load("res://note.tscn")
	var nnote = nres.instantiate()
	nnote.global_position = global_position + Vector2(tab_container.get_global_rect().size.x+40,tab_container.get_global_rect().size.y*0.5-60)
	get_parent().add_child(nnote)
	nnote.pass_targetnode(self)
	note_basis.repos_cam(nnote.global_position + Vector2(160,64))


func _on_options_tab_pressed():
	tab_container.current_tab = 1


func _on_image_tint_button_toggled(toggled_on):
	image_tint.visible = toggled_on


func _on_def_size_button_pressed():
	tab_container.custom_minimum_size = Vector2(320,120)


func get_note_data():
	var nbut : Node2D = line_2d.targetnode
	
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
		"isscrolling": clampi(scroll_container.vertical_scroll_mode,0,1),
		"linetarget": contsaving,
		"text": text.text,
		"tagsarr": tags_array
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
	scroll_container.vertical_scroll_mode = givendic["isscrolling"]
	var contsaving = givendic["linetarget"]
	for chlds in get_parent().get_children():
		if chlds.oldname == contsaving:
			line_2d.targetnode = chlds.reach_targetnode()
	text.text = givendic["text"]
	temp_tags_array = givendic["tagsarr"]


func _on_add_tag_dialog_confirmed():
	note_basis.isnotedialog = false
	#note_basis.canmov = true
	if add_tag_dialog_text.text.strip_edges(true,true) != "":
		temp_tags_array.insert(0,add_tag_dialog_text.text.strip_edges(true,true))
	add_tag_dialog_text.text = ""

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
		2:
			update_tags_optionlist()

func check_tag(tagname):
	if tags_array.has(tagname):
		return self
	else:
		return null


func _on_add_tag_dialog_canceled():
	note_basis.isnotedialog = false
