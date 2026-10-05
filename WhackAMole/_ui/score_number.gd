extends Label

func _ready() -> void:
	GameManager.player_scored.connect(_on_player_scored)
	GameManager.game_state_changed.connect(_on_game_state_changed)
	self.text = str(GameManager.get_current_game_score())

func _on_game_state_changed(new_game_state : GameManager.GameState) -> void:
	if new_game_state == GameManager.GameState.PLAYING:
		self.text = str(GameManager.get_current_game_score())

func _on_player_scored(current_game_score : int) -> void:
	if GameManager.get_game_state() == GameManager.GameState.PLAYING:
		self.text = str(current_game_score)
