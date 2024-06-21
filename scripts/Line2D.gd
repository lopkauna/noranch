extends Line2D

@onready var curve = Curve2D.new()
@onready var connect_to = $".."
@onready var note = $"../../../../../.."
@onready var body = $"../../../.."
@onready var h_box_container = $"../../.."

var targetpos = Vector2(0,0)
var targetnode : Node2D

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
	if note.is_connecting_to == true:
		visible = true
		targetpos = get_global_mouse_position()
	else:
		if targetnode == null:
			visible = false
		else:
			targetpos = targetnode.global_position + Vector2(targetnode.cursize.x+18,targetnode.cursize.y*0.5+35)
	var mousepos = targetpos - global_position
	curve.set_point_position(0,Vector2(connect_to.get_global_rect().size.x*1.1,connect_to.get_global_rect().size.y*0.5))
	
	var otx = abs(mousepos.x*0.75)
	var oty = abs(mousepos.y*0.075) # * sign(mousepos.x)
	curve.set_point_out(0,Vector2(-clampf(otx,0,240),clampf(oty,0,24) * sign(mousepos.y))) #(oty/otx) * sign(mousepos.y)
	curve.set_point_position(1,mousepos)
	curve.set_point_in(1,Vector2(clampf(otx,0,240),clampf(oty,0,24) * sign(mousepos.y))) #(oty/otx) * sign(mousepos.y)
	points = curve.tessellate()
	antialiased = true

func set_targetnode(getbut):
	targetnode = getbut
