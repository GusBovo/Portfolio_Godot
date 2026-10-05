extends Node


func _ready():
	pass

func change_label_text(label : Label, text : String):
	label.text = text

func change_button_text(button_node : Button, text : String):
	button_node.text = text
