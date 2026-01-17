extends Control

# For activating colored shapes for CollisionShape2D and 3D inside the game
# it needs to be togggled in editor.
# Not possible at run-time.
# Might be able to draw_rect(), but not worth it now

var display_fps_toggled : bool = false

func _ready():
	if OS.is_debug_build():
		self.show()
	else:
		self.hide()

func _on_display_fps_toggled(toggled_on):
	if toggled_on:
		display_fps_toggled = true
	else:
		display_fps_toggled = false


func _on_reset_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	GameManager.reset_game_timer()
