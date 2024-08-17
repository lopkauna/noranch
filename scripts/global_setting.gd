extends Node

const current_user_theme_path = "user://curtheme.nrchthem"

var firstrt = false

var AnimatedBG = true
var GridBG = true
var BIFS = true
var current_lines_color := Color(1,1,1,0.565)
var curnotehold = null

var currentpath = ""
var temp_dic = []

var curcolordic := {}

var colorblackdic := {
	notebgcol = Color(0.133,0.133,0.133,0.635),
	noteoutlinecol = Color(0.052,0.052,0.052,1),
	deftextcol = Color(0.875,0.875,0.875,1),
	lineconcol = Color(1,1,1,0.565),
	
	texteditbgcol = Color(0.133,0.133,0.133,0.635),
	texteditoutlinecol = Color(0.051,0.051,0.051,1),
	texteditdeftextcol = Color(0.875,0.875,0.875,1),
	texteditplhldrtextcol = Color(0.875,0.875,0.875,0.6),
	
	buttonbgcol = Color(0.133,0.133,0.133,1),
	buttonoutlncol = Color(0.051,0.051,0.051,1),
	buttontxtcol = Color(0.875,0.875,0.875,1),
	
	buttonhowbgcol = Color(0.198,0.198,0.198,1),
	buttonhowoutlncol = Color(0.8,0.8,0.8,1),
	buttonhowtxtcol = Color(0.875,0.875,0.875,1),
	
	buttonprsbgcol = Color(0.085,0.085,0.085,1),
	buttonprsoutlncol = Color(1,1,1,0),
	buttonprstxtcol = Color(0.875,0.875,0.875,1),
	
	buttondisbgcol = Color(0.6,0.6,0.6,0),
	buttondisoutlncol = Color(0.8,0.8,0.8,0),
	buttondistxtcol = Color(0.875,0.875,0.875,0.5)
}

#var currenttheme = preload("res://scenes/defaulttheme.tres").duplicate()

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(current_user_theme_path):
		var file = FileAccess.open(current_user_theme_path,FileAccess.READ)
		var tempthmdic = file.get_var(true) as Dictionary
		#if not tempthmdic.is_empty():
		curcolordic = tempthmdic
		#else:
		#	curcolordic = colorblackdic
	else:
		curcolordic = colorblackdic
	#set_theme_data(curcolordic)
	Engine.time_scale = 0.1
	#pass # Replace with function body.
	

func crtnstlbox(insbgcolor:Color,insoutlncolor:Color):
	var nstlbx = StyleBoxFlat.new()
	nstlbx.set("bg_color", insbgcolor)
	nstlbx.set("border_color", insoutlncolor)
	nstlbx.set("border_blend", true)
	nstlbx.set("border_width_bottom", 1)
	nstlbx.set("border_width_top", 1)
	nstlbx.set("border_width_right", 1)
	nstlbx.set("border_width_left", 1)
	nstlbx.set("corner_radius_bottom_left", 4)
	nstlbx.set("corner_radius_top_left", 4)
	nstlbx.set("corner_radius_bottom_right", 4)
	nstlbx.set("corner_radius_top_right", 4)

func set_theme_data(inserteddic:Dictionary):
	var notebgcol = inserteddic["notebgcol"]
	var noteoutlinecol = inserteddic["noteoutlinecol"]
	var deftextcol = inserteddic["deftextcol"]
	var lineconcol = inserteddic["lineconcol"]
	
	var texteditbgcol = inserteddic["texteditbgcol"]
	var texteditoutlinecol = inserteddic["texteditoutlinecol"]
	var texteditdeftextcol = inserteddic["texteditdeftextcol"]
	var texteditplhldrtextcol = inserteddic["texteditplhldrtextcol"]
	
	var buttonbgcol = inserteddic["buttonbgcol"]
	var buttonoutlncol = inserteddic["buttonoutlncol"]
	var buttontxtcol = inserteddic["buttontxtcol"]
	
	var buttonhowbgcol = inserteddic["buttonhowbgcol"]
	var buttonhowoutlncol = inserteddic["buttonhowoutlncol"]
	var buttonhowtxtcol = inserteddic["buttonhowtxtcol"]
	
	var buttonprsbgcol = inserteddic["buttonprsbgcol"]
	var buttonprsoutlncol = inserteddic["buttonprsoutlncol"]
	var buttonprstxtcol = inserteddic["buttonprstxtcol"]
	
	var buttondisbgcol = Color(0.6,0.6,0.6,0)
	var buttondisoutlncol = Color(0.8,0.8,0.8,0)
	var buttondistxtcol = Color(0.875,0.875,0.875,0.5)
	
	#currenttheme.set_color("font_color","Label",deftextcol)
	#currenttheme.set_stylebox("panel","Panel",crtnstlbox(notebgcol,noteoutlinecol))
	#current_lines_color = lineconcol
	#
	#currenttheme.set_color("font_color","TextEdit",texteditdeftextcol)
	#currenttheme.set_stylebox("normal","TextEdit",crtnstlbox(texteditbgcol,texteditoutlinecol))
	#currenttheme.set_color("font_placeholder_color","TextEdit",texteditplhldrtextcol)
	#
	#currenttheme.set_color("font_color","Button",buttontxtcol)
	#currenttheme.set_color("font_color","CheckButton",buttontxtcol)
	#currenttheme.set_stylebox("normal","Button",crtnstlbox(buttonbgcol,buttonoutlncol))
	#currenttheme.set_stylebox("normal","CheckButton",crtnstlbox(buttonbgcol,buttonoutlncol))
	#
	#currenttheme.set_color("font_hover_color","Button",buttonhowtxtcol)
	#currenttheme.set_color("font_hover_color","CheckButton",buttonhowtxtcol)
	#currenttheme.set_stylebox("hover","Button",crtnstlbox(buttonhowbgcol,buttonhowoutlncol))
	#currenttheme.set_stylebox("hover","CheckButton",crtnstlbox(buttonhowbgcol,buttonhowoutlncol))
	#
	#currenttheme.set_color("font_pressed_color","Button",buttonprstxtcol)
	#currenttheme.set_color("font_pressed_color","CheckButton",buttonprstxtcol)
	#currenttheme.set_stylebox("pressed","Button",crtnstlbox(buttonprsbgcol,buttonprsoutlncol))
	#currenttheme.set_stylebox("pressed","CheckButton",crtnstlbox(buttonprsbgcol,buttonprsoutlncol))
	#
	#currenttheme.set_color("font_hover_pressed_color","Button",buttonprstxtcol)
	#currenttheme.set_color("font_hover_pressed_color","CheckButton",buttonprstxtcol)
	#currenttheme.set_stylebox("pressed","Button",crtnstlbox(buttonprsbgcol,buttonprsoutlncol))
	#currenttheme.set_stylebox("pressed","CheckButton",crtnstlbox(buttonprsbgcol,buttonprsoutlncol))
	#currenttheme.set_stylebox("hover_pressed","CheckButton",crtnstlbox(buttonprsbgcol,buttonprsoutlncol))
	#
	#currenttheme.set_color("font_disabled_color","Button",buttondistxtcol)
	#currenttheme.set_color("font_disabled_color","CheckButton",buttondistxtcol)
	#currenttheme.set_stylebox("disabled","Button",crtnstlbox(buttondisbgcol,buttondisoutlncol))
	#currenttheme.set_stylebox("disabled","CheckButton",crtnstlbox(buttondisbgcol,buttondisoutlncol))
	#currenttheme.set_stylebox("focus","Button",crtnstlbox(buttondisbgcol,buttondisoutlncol))
	#currenttheme.set_stylebox("focus","CheckButton",crtnstlbox(buttondisbgcol,buttondisoutlncol))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
