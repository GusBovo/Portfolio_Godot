class_name Soundwave extends Node3D

@onready var outer_area = $OuterArea3D
@onready var outer_area_collision = $OuterArea3D/CollisionPolygon3D
@onready var animation_player = $AnimationPlayer

signal entered_ring
signal finished

# Engine Methods
func _ready() -> void:
	outer_area.monitorable = false
	outer_area.monitoring = false
	outer_area.collision_layer = 2
	outer_area.collision_mask = 2
	outer_area_collision.disabled = false
	animation_player.play("idle")

# My Methods
func set_soundwave(position_vector : Vector3) -> void:
	self.position = position_vector

func emit_soundwave() -> void:
	outer_area.set_deferred("monitoring", true)
	outer_area.set_deferred("monitorable", true)
	animation_player.connect("animation_finished", _on_animation_finished)
	animation_player.play("ring_expansion")

# Signals

# REMEMBER: It will be freed after emitting this
func _on_animation_finished(animation_name : StringName) -> void:
	if animation_name == "ring_expansion":
		emit_signal("finished")

func _on_outer_area_3d_area_entered(area: Area3D) -> void:
	outer_area.set_deferred("monitoring", false)
	outer_area.set_deferred("monitorable", false)
	emit_signal("entered_ring")
	print_debug(str(area) + " has entered soundwave ring")
