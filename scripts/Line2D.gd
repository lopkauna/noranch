extends Line2D

@onready var curve = Curve2D.new()
@onready var connect_to = $".."
@onready var note = $"../../../../../.."
@onready var body = $"../../../.."
@onready var h_box_container = $"../../.."

var targetpos = Vector2(0,0)
var targetnode : Node2D
enum sides {
	up,
	down,
	left,
	right
}
var parside = sides.right
var tarside = sides.right

# Called when the node enters the scene tree for the first time.
func _ready():
	parside = sides.right
	tarside = sides.right
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(0,0))
	#curve.add_point(Vector2(0,0))
	set_joint_mode(2)
	set_end_cap_mode(2)
	set_begin_cap_mode(2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var nodesposdifference = Vector2(0,0)
	if note.is_connecting_to == true:
		visible = true
		targetpos = get_global_mouse_position()
		var nodesposdifference = note.get_note_center_pos() - targetpos
		if abs(nodesposdifference.x) >= abs(nodesposdifference.y):
			if nodesposdifference.x > 0:
				parside = sides.right
			else:
				parside = sides.left
		else:
			if nodesposdifference.y>0:
				parside = sides.down
			else:
				parside = sides.up
	else:
		if targetnode == null:
			visible = false
		else:
			visible = true
			var nodesposdifference = note.get_note_center_pos() - targetnode.get_note_center_pos()
			if abs(nodesposdifference.x)>=abs(nodesposdifference.y):
				if nodesposdifference.x>0:
					targetpos = targetnode.global_position + Vector2(targetnode.cursize.x+18,targetnode.cursize.y*0.5+35)
					tarside = sides.right
				else:
					targetpos = targetnode.global_position + Vector2(18,targetnode.cursize.y*0.5+35)
					tarside = sides.left
				if note.global_position.x == clampf(note.global_position.x
				,targetnode.global_position.x-note.cursize.x-24,targetnode.global_position.x+targetnode.cursize.x+24):
					if note.global_position.y == clampf(note.global_position.y
					,targetnode.global_position.y-note.cursize.y,targetnode.global_position.y+targetnode.cursize.y):
						if nodesposdifference.x>0:
							parside = sides.right
						else:
							parside = sides.left
					else:
						if nodesposdifference.y>0:
							parside = sides.down
						else:
							parside = sides.up
				else:
					if nodesposdifference.x>0:
						parside = sides.right
					else:
						parside = sides.left
			else:
				if nodesposdifference.y>0:
					targetpos = targetnode.global_position + Vector2(targetnode.cursize.x*0.5+18,targetnode.cursize.y+35)
					tarside = sides.down
					parside = sides.down
				else:
					targetpos = targetnode.global_position + Vector2(targetnode.cursize.x*0.5+18,35)
					tarside = sides.up
					parside = sides.up
	var mousepos = targetpos - global_position
	match tarside:
		sides.up:
			var otx = abs(mousepos.x*0.075)
			var oty = abs(mousepos.y*0.5)
			curve.set_point_position(1,mousepos)
			curve.set_point_in(1,Vector2(-clampf(otx,0,24),clampf(oty,0,240) * -sign(mousepos.y))) 
		sides.down:
			var otx = abs(mousepos.x*0.075)
			var oty = abs(mousepos.y*0.5)
			curve.set_point_position(1,mousepos)
			curve.set_point_in(1,Vector2(clampf(otx,0,24),clampf(oty,0,240) * -sign(mousepos.y))) 
		sides.left:
			var otx = abs(mousepos.x*0.75 - note.cursize.x)
			var oty = abs(mousepos.y*0.075)
			curve.set_point_position(1,mousepos)
			if parside == sides.up or parside == sides.down:
				curve.set_point_in(1,Vector2(-clampf(otx*0.1,0,240),clampf(oty,0,24) * sign(mousepos.y))) 
			else:
				curve.set_point_in(1,Vector2(-clampf(otx,0,240),clampf(oty,0,24) * sign(mousepos.y))) 
		sides.right:
			var otx = abs(mousepos.x*0.75)
			var oty = abs(mousepos.y*0.075)
			curve.set_point_position(1,mousepos)
			if parside == sides.up or parside == sides.down:
				curve.set_point_in(1,Vector2(clampf(otx*0.1,0,240),clampf(oty,0,24) * sign(mousepos.y))) 
			else:
				curve.set_point_in(1,Vector2(clampf(otx,0,240),clampf(oty,0,24) * sign(mousepos.y))) 
	match parside:
		sides.up:
			var otx = abs(mousepos.x*0.075)
			var oty = abs(mousepos.y*0.5)
			curve.set_point_position(0,Vector2(note.cursize.x*0.5+18,note.cursize.y*0.5+connect_to.get_global_rect().size.y*0.5))
			curve.set_point_out(0,Vector2(clampf(otx,0,240),clampf(oty,0,240) * sign(mousepos.y)))
		sides.down:
			var otx = abs(mousepos.x*0.075)
			var oty = abs(mousepos.y*0.5)
			curve.set_point_position(0,Vector2(note.cursize.x*0.5+18,-note.cursize.y*0.5+connect_to.get_global_rect().size.y*0.5))
			curve.set_point_out(0,Vector2(-clampf(otx,0,24),clampf(oty,0,240) * sign(mousepos.y)))
		sides.left:
			var otx = abs(mousepos.x*0.75 - note.cursize.x)
			var oty = abs(mousepos.y*0.075)
			curve.set_point_position(0,Vector2(connect_to.get_global_rect().size.x*0.9 + note.cursize.x,connect_to.get_global_rect().size.y*0.5))
			curve.set_point_out(0,Vector2(clampf(otx,0,240),clampf(oty,0,24) * sign(mousepos.y))) 
		sides.right:
			var otx = abs(mousepos.x*0.75)
			var oty = abs(mousepos.y*0.075)
			curve.set_point_position(0,Vector2(connect_to.get_global_rect().size.x*1.1,connect_to.get_global_rect().size.y*0.5))
			curve.set_point_out(0,Vector2(-clampf(otx,0,240),clampf(oty,0,24) * sign(mousepos.y)))
	
	points = curve.tessellate()
	antialiased = true

func set_targetnote(getbut):
	targetnode = getbut

func get_papa_note():
	return note
