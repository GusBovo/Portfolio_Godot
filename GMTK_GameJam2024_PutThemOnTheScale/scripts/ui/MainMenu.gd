extends Control


func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass

func _on_start_button_pressed():
	var game_scene = preload("res://scenes/main/Game.tscn")
	get_tree().change_scene_to_packed(game_scene)

func _on_options_button_pressed():
	$MainMenuVBox.hide()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_options_menu_hidden():
	$MainMenuVBox.show()
