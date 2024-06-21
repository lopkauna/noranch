extends MarginContainer

@onready var h_flow_container = $HFlowContainer
@onready var tags_click = $TagsClick
@onready var panel = $"../Panel"

# Called when the node enters the scene tree for the first time.
func _ready():
	if h_flow_container.get_child_count() == 0:
		tags_click.visible = false
		panel.visible = false
		add_theme_constant_override("margin_top",0)
		add_theme_constant_override("margin_bottom",0)
		add_theme_constant_override("margin_left",0)
		add_theme_constant_override("margin_right",0)
	else:
		tags_click.visible = true
		panel.visible = true
		add_theme_constant_override("margin_top",4)
		add_theme_constant_override("margin_bottom",4)
		add_theme_constant_override("margin_left",4)
		add_theme_constant_override("margin_right",4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if h_flow_container.get_child_count() == 0:
		tags_click.visible = false
		panel.visible = false
		add_theme_constant_override("margin_top",0)
		add_theme_constant_override("margin_bottom",0)
		add_theme_constant_override("margin_left",0)
		add_theme_constant_override("margin_right",0)
	else:
		tags_click.visible = true
		panel.visible = true
		add_theme_constant_override("margin_top",4)
		add_theme_constant_override("margin_bottom",4)
		add_theme_constant_override("margin_left",4)
		add_theme_constant_override("margin_right",4)
