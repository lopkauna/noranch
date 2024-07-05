extends Line2D

@onready var decoy_text_edit = $"../VBoxContainer/ThemePreview/FlowContainer/DecoyTextEdit"
@onready var decoy_button = $"../VBoxContainer/ThemePreview/FlowContainer/DecoyButton"

@onready var curve = Curve2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(0,0))
	#curve.add_point(Vector2(0,0))
	set_joint_mode(2)
	set_end_cap_mode(2)
	set_begin_cap_mode(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = decoy_text_edit.global_position
	var mousepos = decoy_button.global_position - global_position
	curve.set_point_position(0,Vector2(2,decoy_text_edit.get_global_rect().size.y*0.5))
	var lngth = mousepos.length()
	var otx = abs(mousepos.x*0.75)
	var oty = abs(mousepos.y*0.075) # * sign(mousepos.x)
	curve.set_point_out(0,Vector2(-24,0))#(oty/otx) * sign(mousepos.y)
	curve.set_point_position(1,mousepos+Vector2(2,decoy_button.get_global_rect().size.y*0.5))
	curve.set_point_in(1,Vector2(-24,0)) #(oty/otx) * sign(mousepos.y)
	points = curve.tessellate()
	antialiased = true
