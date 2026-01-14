extends Camera3D

const INIT_FOV : float = 90.0
const ADD_SPRINT_FOV : float = 20.0
const FOV_CHANGE_SPEED : float = 30
const SPRINT_FOV = INIT_FOV + ADD_SPRINT_FOV

var has_focus : bool = true
var is_sprinting : bool = false

# Engine

func _init() -> void:
	fov = INIT_FOV
	current = true

func _ready() -> void:
	owner.connect("sprint_triggered", _on_sprint_triggered)
	owner.connect("sprint_released", _on_sprint_released)

func _process(delta: float) -> void:
	change_fov(delta)

# Signals

func _on_sprint_triggered() -> void:
	if !is_sprinting:
		is_sprinting = true

func _on_sprint_released() -> void:
	if is_sprinting:
		is_sprinting = false

# Custom

func change_fov(delta : float):
	if fov != INIT_FOV and !is_sprinting:
		fov = move_toward(fov, INIT_FOV, FOV_CHANGE_SPEED * delta)
	if fov != SPRINT_FOV and is_sprinting:
		#print_debug("FOV changing")
		fov = move_toward(fov, SPRINT_FOV, FOV_CHANGE_SPEED * delta)
