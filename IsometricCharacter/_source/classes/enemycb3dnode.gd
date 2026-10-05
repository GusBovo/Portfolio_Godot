class_name EnemyCB3DClass
extends CharacterBody3D

@export var enemy_name : String = ""
@export var max_health : int = 0
@export var current_health : int = 0
@export var soundwave_wait_time : float = 0.7

@onready var damage_display_anchor : Marker3D =  self.get_node("3D/DamageDisplayAnchor")
@onready var health_bar_display : Node3D = self.get_node("3D/HealthBarDisplay")
@onready var name_label : Label3D = self.get_node("3D/NameLabel3D")
@onready var soundwave_spawn_timer : Timer = self.get_node("Generic/SoundwaveSpawnTimer")

var damage_display := preload("res://_scenes/components/damage_display.tscn")
var soundwave_res := preload("res://_scenes/soundwave.tscn")

# Engine Methods

func _ready() -> void:
	health_bar_display.emit_signal("max_health_changed", max_health)
	health_bar_display.emit_signal("health_changed", current_health, max_health)
	name_label.text = enemy_name
	soundwave_spawn_timer.wait_time = soundwave_wait_time
	soundwave_spawn_timer.connect("timeout", _on_soundwave_spawn_timer_timeout)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta 
	else:
		velocity.y = 0
	
	move_and_slide()
	
	if soundwave_spawn_timer.is_stopped():
		soundwave_spawn_timer.start()

# My Methods

func display_damage(damage_amount) -> void:
	var display_instance := damage_display.instantiate()
	display_instance.get_node("Label3D").text = str(damage_amount)
	damage_display_anchor.add_child(display_instance)
	display_instance.get_node("AnimationPlayer").play("label_path")

func take_damage(amount : int) -> void:
	display_damage(amount)
	if (current_health - amount) <= 0:
		current_health = 0
		health_bar_display.emit_signal("health_changed", current_health, max_health)
		return
	current_health -= amount
	health_bar_display.emit_signal("health_changed", current_health, max_health)

func spawn_soundwave() -> void:
	var soundwave := soundwave_res.instantiate()
	soundwave.set_soundwave(self.position)
	soundwave.connect("finished", _on_soundwave_finished.bind(soundwave))
	get_tree().current_scene.add_child(soundwave)
	soundwave.emit_soundwave()

# Attached Signals

func _on_hurtbox_3d_area_entered(area: Area3D) -> void:
	print(str(area) + " entered " + enemy_name + "'s hurtbox")
	if area.has_method("damage_enemy"):
		take_damage(area.damage_enemy())

func _on_soundwave_finished(soundwave) -> void:
	print_debug(str(soundwave) + " soundwave should be queued for deletion now")
	soundwave.queue_free()

func _on_soundwave_spawn_timer_timeout() -> void:
	spawn_soundwave()
