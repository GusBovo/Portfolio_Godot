extends CharacterBody3D

const SPEED : float = 5.0

@onready var health_bar_display = $"../Enemy_MegaphoneGuy/HealthBarDisplay"

var enemy_name : String = "Megaphone Guy"
var max_health : int = 150
var current_health : int = max_health

# Engine Methods

func _ready() -> void:
	$Outline.visible = false
	health_bar_display.emit_signal("max_health_changed", max_health)
	health_bar_display.emit_signal("health_changed", current_health, max_health)
	assert(current_health <= max_health, enemy_name + " " + str(owner) + "'s current_health higher than it's max_health")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta 
	else:
		velocity.y = 0
	
	move_and_slide()

# Methods

func take_damage(amount : int) -> void:
	if (current_health - amount) <= 0:
		current_health = 0
		health_bar_display.emit_signal("health_changed", current_health, max_health)
		return
	current_health -= amount
	health_bar_display.emit_signal("health_changed", current_health, max_health)

# Signals

func _on_detection_area_mouse_entered() -> void:
	$Outline.visible = true

func _on_detection_area_mouse_exited() -> void:
	$Outline.visible = false

func _on_hurtbox_area_entered(area: Area3D) -> void:
	print(str(area) + " entered " + enemy_name + "'s hurtbox")
	if area.has_method("damage_enemy"):
		take_damage(area.damage_enemy())
