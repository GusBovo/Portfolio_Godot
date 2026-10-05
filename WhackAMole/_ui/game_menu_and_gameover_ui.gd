extends Control

@onready var close_button: Button = %CloseButton
@onready var play_button: Button = %PlayButton
@onready var final_score_number: Label = %FinalScoreNumber
@onready var final_score: Label = %FinalScore

func _ready() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)
	
	close_button.pressed.connect(_on_close_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	
	hide_all_ui()
	_on_game_state_changed(GameManager.get_game_state())

func hide_all_ui() -> void:
	final_score.visible = false
	final_score_number.visible = false
	close_button.visible = false
	close_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	play_button.visible = false
	play_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func open_end_game_menu() -> void:
	final_score.visible = true
	final_score_number.visible = true
	final_score_number.text = str(GameManager.get_current_game_score())
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.visible = true
	play_button.mouse_filter = Control.MOUSE_FILTER_STOP
	play_button.visible = true

func open_main_menu() -> void:
	if final_score.visible:
		final_score.visible = false
	if final_score_number.visible:
		final_score_number.visible = false
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.visible = true
	play_button.mouse_filter = Control.MOUSE_FILTER_STOP
	play_button.visible = true

func _on_close_button_pressed() -> void:
	get_tree().quit()

func _on_game_state_changed(new_game_state : GameManager.GameState) -> void:
	if new_game_state == GameManager.GameState.MENU:
		print_debug("GameMenuAndGameOverUI - Should be showing main menu UI now")
		open_main_menu()
	if new_game_state == GameManager.GameState.PLAYING:
		print_debug("GameMenuAndGameOverUI - Should be hiding all UI now")
		hide_all_ui()
	if new_game_state == GameManager.GameState.GAME_OVER:
		print_debug("GameMenuAndGameOverUI - Should be showing end game UI now")
		open_end_game_menu()
		

func _on_play_button_pressed() -> void:
	GameManager.request_game_start()
