extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bbcode_enabled = true
	get_parent().hide()
	get_parent().get_node("Button").pressed.connect(_on_clicked_restart)
	GameManager.end_the_game.connect(_on_game_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_game_ended(weight : float) -> void:
	text = "[center]CONGRATULATIONS!\n\nYOU HAVE REACHED THE MOON!\n\nAND ALL THAT WITH A TOTAL WEIGHT OF:\n" + str(weight) + "kg[/center]"
	get_parent().show()
	get_tree().paused = true

func _on_clicked_restart() -> void:
	get_parent().get_parent().get_parent().get_parent().get_tree().reload_current_scene()
