extends Control

func _ready() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)
	
	_on_game_state_changed(GameManager.get_game_state())

func hide_all_game_ui() -> void:
	self.visible = false

func show_all_game_ui() -> void:
	self.visible = true

func _on_game_state_changed(new_game_state : GameManager.GameState) -> void:
	if new_game_state == GameManager.GameState.PLAYING:
		print_debug("GameUI - Should be showing GameUI now")
		show_all_game_ui()
		return
	print_debug("GameUI - Should be hiding GameUI now")
	hide_all_game_ui()
