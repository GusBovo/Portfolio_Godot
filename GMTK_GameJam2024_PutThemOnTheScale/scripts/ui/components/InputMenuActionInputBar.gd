extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func set_action_input_bar(action_text : String, event_key : InputEvent):
	UIManager.change_label_text($ColorRect/HBoxContainer/Label, action_text)
	UIManager.change_button_text($ColorRect/HBoxContainer/Button, event_key.as_text())
