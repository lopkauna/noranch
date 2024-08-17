extends ParallaxLayer
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera_2d: Camera2D = $"../../Camera2D"

var windsiz = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if windsiz != Vector2(int(DisplayServer.window_get_size().x/64),int(DisplayServer.window_get_size().y/64))*64:
		for vrx in int(DisplayServer.window_get_size().x/64):
			for vry in int(DisplayServer.window_get_size().y/64):
				tile_map_layer.set_cell(Vector2(vrx,vry),0,Vector2i(0,0))
				if vrx == int(DisplayServer.window_get_size().x/64)-1 and vry == int(DisplayServer.window_get_size().y/64)-1:
					windsiz = Vector2(int(DisplayServer.window_get_size().x/64),int(DisplayServer.window_get_size().y/64))*64
					motion_mirroring = windsiz
	scale = camera_2d.zoom
