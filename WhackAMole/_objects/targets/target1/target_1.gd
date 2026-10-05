extends Area3D

var hide_timer := Timer.new()

var hide_delay : float = 4.0

var target_is_hidden : bool = true

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	add_to_group("Target")
	
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.wait_time = hide_delay
	
	GameManager.game_state_changed.connect(_on_game_state_changed)
	hide_timer.timeout.connect(_on_hide_timer_timeout)

func hide_target() -> void:
	if target_is_hidden:
		return
	animation_player.play("hide")
	await animation_player.animation_finished
	animation_player.play("hidden")
	target_is_hidden = true

func hit_target() -> void:
	animation_player.play("hit")
	await animation_player.animation_finished
	GameManager.score()
	animation_player.play("hidden")
	target_is_hidden = true

func is_target_hidden() -> bool:
	return target_is_hidden

func show_target() -> void:
	animation_player.play("show_up")
	await animation_player.animation_finished
	hide_timer.start()
	target_is_hidden = false

func _on_game_state_changed(new_game_state : GameManager.GameState) -> void:
	if new_game_state == GameManager.GameState.GAME_OVER and not target_is_hidden:
		animation_player.play("hidden")

func _on_hide_timer_timeout() -> void:
	hide_target()
