class_name Hurtbox
extends Area3D

func _init() -> void:
	self.collision_layer = 0 # no layer needed for hurtbox
	self.collision_mask = 2 # hurtbox mask for detection of hitboxes
