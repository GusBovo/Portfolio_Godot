extends Node

signal game_state_changed(new_game_state : GameState)
signal player_scored(new_game_score : int)

enum GameState {
	GAME_OVER,
	MENU, 
	PLAYING,
}

const GAME_TIME_MAX : float = 10.0 #180.0 # 3 min.

var game_timer := Timer.new()
var target_show_timer := Timer.new()

var target_show_delay : float = 3.0

var current_game_score : int = 0

var current_game_state : GameState

func _ready() -> void:
	add_child(game_timer)
	add_child(target_show_timer)
	
	game_timer.one_shot = true
	target_show_timer.one_shot = true
	
	game_timer.wait_time = GAME_TIME_MAX
	target_show_timer.wait_time = target_show_delay
	
	game_timer.timeout.connect(_on_game_timer_timeout)
	target_show_timer.timeout.connect(_on_target_show_timer_timeout)
	
	self.game_state_changed.connect(_on_game_state_changed)
	
	__set_game_state_menu()

func get_current_game_score() -> int:
	return current_game_score

func get_current_game_time() -> float:
	return GAME_TIME_MAX - game_timer.time_left

func get_max_game_time() -> float:
	return GAME_TIME_MAX

func get_remaining_game_time() -> float:
	return game_timer.time_left

func get_game_state() -> GameState:
	return current_game_state

func request_game_start() -> void:
	__set_game_state_playing()

func score() -> void:
	current_game_score += 1
	player_scored.emit(current_game_score)

func _on_game_state_changed(new_game_state : GameState) -> void:
	if new_game_state == GameState.PLAYING:
		current_game_score = 0
		game_timer.start()
		target_show_timer.start()
	if new_game_state == GameState.GAME_OVER:
		game_timer.stop()
		target_show_timer.stop()

func _on_game_timer_timeout() -> void:
	__set_game_state_game_over()

func _on_target_show_timer_timeout() -> void:
	var targets = get_tree().get_nodes_in_group("Target")
	if targets.is_empty():
		print_debug("GameController._on_target_show_timer_timeout: Targets array is empty for some reason")
		return
	var random_target = targets.pick_random()
	while not random_target.is_target_hidden():
		print_debug("GameController._on_target_show_timer_timeout: " + random_target.name + " is not hidden, choosing another...")
		random_target = targets.pick_random()
	random_target.show_target()
	target_show_timer.start()

func __set_game_state_game_over() -> void:
	current_game_state = GameState.GAME_OVER
	game_state_changed.emit(current_game_state)

func __set_game_state_menu() -> void:
	current_game_state = GameState.MENU
	game_state_changed.emit(current_game_state)

func __set_game_state_playing() -> void:
	current_game_state = GameState.PLAYING
	game_state_changed.emit(current_game_state)
