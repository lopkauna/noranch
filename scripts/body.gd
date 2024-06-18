extends MarginContainer

@onready var tab_container = $TabContainer
@onready var rich_label = $TabContainer/Text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tab_container.tabs_visible = false
	if get_global_mouse_position().x == clampf(get_global_mouse_position().x,get_global_rect().position.x,get_global_rect().end.x):#get_global_rect().position.x <= get_global_mouse_position().x and get_global_rect().end.x >= get_global_mouse_position().x:
		if get_global_mouse_position().y == clampf(get_global_mouse_position().y,get_global_rect().position.y,get_global_rect().end.y):#get_global_rect().position.y <= get_global_mouse_position().y and get_global_rect().end.y >= get_global_mouse_position().y:
			tab_container.tabs_visible = true



func _on_fitin_toggled(toggled_on):
	#print(toggled_on)
	rich_label.fit_content = toggled_on
