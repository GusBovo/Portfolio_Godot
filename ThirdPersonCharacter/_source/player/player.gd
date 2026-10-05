extends CharacterBody3D

const SPEED : float = 5.0
const ADDED_SPEED : float = 3.0
const JUMP_VELOCITY : float = 4.5
const SPRINT_SPEED : float = SPEED + ADDED_SPEED

@export var cam_system : Node3D
@export var mouse_x_sensibility : float = 0.005

var is_sprinting : bool = false
var is_aiming_down_sights : bool = false

var has_direction : bool = false

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.screen_relative.x * mouse_x_sensibility
		rotation.y = wrapf(rotation.y, 0.0, TAU)

# Custom

func set_velocity_from_motion(new_velocity : Vector3) -> void:
	velocity = new_velocity