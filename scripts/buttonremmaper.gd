extends Button

@onready var settings = $"../../../../../../../../.."
@export var action: String

func _init():
	toggle_mode = true

func _ready():
	set_process_input(false)

func _toggled(toggled_on):
	set_process_input(toggled_on)
	if button_pressed:
		text = "Awaiting input"
	

func _input(event):
	if self.is_hovered():
		if event is InputEventMouseButton and event.is_released():
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action,event)
			button_pressed = false
			release_focus()
			update_text()
			settings.keymaps[action] = event
			settings.save_keymaps()
	else:
		if event is InputEventMouseButton and event.is_pressed():
			button_pressed = false
			release_focus()
			update_text()
	if event is InputEventKey and event.is_released():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action,event)
		button_pressed = false
		release_focus()
		update_text()
		settings.keymaps[action] = event
		settings.save_keymaps()
	

func update_text():
	text = InputMap.action_get_events(action)[0].as_text()
