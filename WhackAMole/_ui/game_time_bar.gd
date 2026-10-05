extends ProgressBar

@onready var game_time_label: Label = %GameTimeLabel

func _ready() -> void:
	self.value = 0
	__update_time_label(GameManager.get_max_game_time())

func _physics_process(_delta: float) -> void:
	if GameManager.get_game_state() == GameManager.GameState.PLAYING:
		__update_time_label(GameManager.get_remaining_game_time())
		__update_time_bar()

func __update_time_bar() -> void:
	self.value = (GameManager.get_current_game_time() * 100.0) / GameManager.get_max_game_time()

func __update_time_label(time_left : float) -> void:
	var minutes := int(time_left / 60)
	var seconds := int(time_left) % 60
	
	game_time_label.text = "%02d:%02d" % [minutes, seconds]
