extends Node3D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal finished

func set_counterwave(position_value : Vector3) -> void:
	self.position = position_value

func emit_counterwave() -> void:
	animation_player.connect("animation_finished", _on_counterwave_animation_finished)
	animation_player.play("ring_expansion")

# Signals

# REMEMBER: It will be freed after emitting this
func _on_counterwave_animation_finished(animation_name : StringName) -> void:
	if animation_name == "ring_expansion":
		emit_signal("finished")
