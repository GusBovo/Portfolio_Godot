extends SpringArm3D

const MAX_OUTER_SPRING_LENGTH : float = 2.0
const MAX_SPRINT_SPRING_LENGTH : float = 1.3
const MAX_AIM_DOWN_SIGHTS_SPRING_LENGTH : float = 0.7
const AIM_CHANGE_SPEED : float = 9.5
const SPRINT_CHANGE_SPEED : float = 1.0

@export var mouse_y_sensibility : float = 0.005

var is_aiming_down_sights = false
var is_sprinting = false

# Engine

func _ready() -> void:
	add_excluded_object(owner)
	print_debug(str(owner) + " has been added as excluded object for cam SpringArm3D")
	owner.connect("sprint_triggered", _on_sprint_triggered)
	owner.connect("sprint_released", _on_sprint_released)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("RMB"):
			is_aiming_down_sights = true
		if event.is_action_released("RMB"):
			is_aiming_down_sights = false
		#print_debug("is aiming down sights? " + str(is_aiming_down_sights))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.x -= event.screen_relative.y * mouse_y_sensibility
		rotation.x = clampf(rotation.x, -PI/3, PI/4)

func _process(delta: float) -> void:
	sprint(delta)
	aim_down_sights(delta)

# Signals

func _on_sprint_triggered() -> void:
	if !is_sprinting:
		is_sprinting = true

func _on_sprint_released() -> void:
	if is_sprinting:
		is_sprinting = false

# Custom
func aim_down_sights(delta : float) -> void:
	if is_sprinting:
		return
	if !is_equal_approx(spring_length, MAX_AIM_DOWN_SIGHTS_SPRING_LENGTH) and is_aiming_down_sights:
		#print_debug("Entered aim down sights()")
		spring_length = move_toward(spring_length, MAX_AIM_DOWN_SIGHTS_SPRING_LENGTH, AIM_CHANGE_SPEED * delta)
		#print_debug("Spring length - aiming down: " + str(spring_length))
	else:
		restore_aim(delta)

func restore_aim(delta : float) -> void:
	if !is_equal_approx(spring_length, MAX_OUTER_SPRING_LENGTH) and !is_aiming_down_sights:
		#print_debug("Entered restore aim()")
		spring_length = move_toward(spring_length, MAX_OUTER_SPRING_LENGTH, AIM_CHANGE_SPEED * delta)
		#print_debug("Spring length - restoring aim: " + str(spring_length))

func sprint(delta : float) -> void:
	if !is_equal_approx(spring_length, MAX_SPRINT_SPRING_LENGTH) and is_sprinting:
		spring_length = move_toward(spring_length, MAX_SPRINT_SPRING_LENGTH, SPRINT_CHANGE_SPEED * delta)
	else:
		stop_sprint(delta)

func stop_sprint(delta : float) -> void:
	if !is_equal_approx(spring_length, MAX_OUTER_SPRING_LENGTH) and !is_sprinting:
		spring_length = move_toward(spring_length, MAX_OUTER_SPRING_LENGTH, SPRINT_CHANGE_SPEED * delta)
