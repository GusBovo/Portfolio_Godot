extends Node3D

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "label_path":
		queue_free()
