extends CharacterBody3D

const SPEED = 5.0
const MAX_HEALTH := 100

var current_health := MAX_HEALTH # Always initialize full health, needs change
var is_attacking := false

@onready var weapon_hitbox = $Weapon_Mesh/Weapon_Hitbox
@onready var animation_player = $AnimationPlayer
@onready var health_bar_display = $HealthBarDisplay

# Engine Methods

func _ready() -> void:
	player_health_init()
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	var raw_input := Input.get_vector("WalkLeft", "WalkRight", "WalkUp", "WalkDown")
	var input_dir := Vector2(raw_input.x, -raw_input.y) # get_vector: y = down - up → inverter
	# Vetores da câmera (robusto para qualquer rotação)
	var cam := $Isometric_Camera
	var forward = -cam.global_transform.basis.z
	var right = cam.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	#look_at(cam.get_viewport().get_mouse_position())
	
	if input_dir.length() > 0.0:
		var direction = (forward * input_dir.y + right * input_dir.x).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# deactivated smooth deacceleration
		velocity.x = 0 # move_toward(velocity.x, 0.0, SPEED * delta)
		velocity.z = 0 # move_toward(velocity.z, 0.0, SPEED * delta)
	
	if not is_on_floor():
		velocity.y -= 9.8 * delta 
	else:
		velocity.y = 0
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void: # unhandled input might cause calling order problems
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_attacking = true
				weapon_hitbox.activate_hitbox()
				animation_player.play("attack")
			if not event.pressed:
				is_attacking = false


# Script Methods

func player_health_change(health_amount) -> void:
	health_bar_display.emit_signal("health_changed", health_amount, MAX_HEALTH) # should change const for a var later

func player_health_init() -> void:
	health_bar_display.emit_signal("max_health_changed", MAX_HEALTH)
	health_bar_display.emit_signal("health_changed", current_health, MAX_HEALTH) # should change const for a var later

func player_max_health_change(max_health_amount) -> void:
	health_bar_display.emit_signal("max_health_changed", max_health_amount)

# Attached Signals

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		weapon_hitbox.deactivate_hitbox()
		if is_attacking:
			weapon_hitbox.activate_hitbox()
			animation_player.play("attack")
		if not is_attacking:
			animation_player.play("idle")
