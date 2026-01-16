class_name WeaponHitbox
extends Area3D

@export var damage : int = 10

@onready var hit_marker = $"../../HitMarker"

var counterwave_res = preload("res://_scenes/counterwave.tscn")

# Engine Methods

func _init() -> void:
	self.collision_layer = 2 # hitbox layer
	self.collision_mask = 2 # no need for mask on hitbox (afaik)

func _ready() -> void:
	connect("area_entered", _on_weapon_hitbox_area_entered)

# Script Methods

func activate_hitbox() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT

func deactivate_hitbox() -> void: 
	self.process_mode = Node.PROCESS_MODE_DISABLED

func damage_enemy() -> int:
	return damage

func spawn_counterwave() -> void:
	var counterwave = counterwave_res.instantiate()
	counterwave.set_counterwave(hit_marker.global_position)
	counterwave.connect("finished", _on_counterwave_finished.bind(counterwave))
	get_tree().current_scene.add_child(counterwave)
	counterwave.emit_counterwave()

# Signals

func _on_weapon_hitbox_area_entered(area : Area3D) -> void:
	print_debug("Weapon just hitted something...")
	if area.owner is Soundwave:
		print_debug("Weapon hitted Soundwave area(" + str(area) + ")")
		spawn_counterwave()

func _on_counterwave_finished(counterwave : Node3D) -> void:
	print_debug(str(counterwave) + "counterwave should be queued for deletion now")
	counterwave.queue_free()
