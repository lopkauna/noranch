extends TileMapLayer

@onready var camera_2d: Camera2D = $"../Camera2D"

var windsiz = Vector2(0,0)

var loffset = Vector2(0,0)
var cloffset = Vector2(0,0)
var camzm = Vector2(1,1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cloffset.x = camera_2d.global_position.x-(int(camera_2d.global_position.x/64)*64)
	cloffset.y = camera_2d.global_position.y-(int(camera_2d.global_position.y/64)*64)
	loffset.x = camera_2d.global_position.x
	loffset.y = camera_2d.global_position.y
	modulate.a = (0.25*camera_2d.zoom.x)*0.5
	var mxx = int((DisplayServer.window_get_size().x/camera_2d.zoom.x)/64)+4
	var mxy = int((DisplayServer.window_get_size().y/camera_2d.zoom.y)/64)+4
	for vrx in mxx:
		for vry in mxy:
			set_cell(Vector2(vrx-int(mxx*0.5),vry-int(mxy*0.5)),0,Vector2i(0,0))
			if vrx == int(DisplayServer.window_get_size().x/64)+3 and vry == int(DisplayServer.window_get_size().y/64)+3:
				windsiz = Vector2(int(DisplayServer.window_get_size().x/64),int(DisplayServer.window_get_size().y/64))*64
	global_position = loffset - cloffset
