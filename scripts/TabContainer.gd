extends TabContainer

var vibl = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#vibl = move_toward(vibl,0,delta)
	if vibl <= 0:
		tabs_visible = false
	else:
		tabs_visible = true


func _on_mouse_entered():
	vibl = 1


func _on_mouse_exited():
	vibl = 0
