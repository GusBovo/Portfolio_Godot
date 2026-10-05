extends SpringArm3D

const SHOULDER_LERP_WEIGHT : float = 0.37 # Think of it as a step percentage taken towards the compared result
const MAX_INNER_SPRING_LENGTH : float = 0.9

@onready var outer_spring_arm : SpringArm3D = $OuterSpringArm3D

#FLAGS
var has_shoulder_changed : bool = false
var is_right_shoulder : bool = true

# Engine

func _init() -> void:
	GameInput.connect("triggered_shoulder_change", _on_triggered_shoulder_change)

func _ready() -> void:
	add_excluded_object(owner)
	spring_length = MAX_INNER_SPRING_LENGTH
	assert(spring_length <= MAX_INNER_SPRING_LENGTH, "Something is wrong with CamInnerArm spring length initial value - spring_length: " + str(spring_length))

func _process(_delta: float) -> void:
	change_alignment()

# Signals

func _on_triggered_shoulder_change() -> void:
	print_debug("Triggered shoulder change")
	if !has_shoulder_changed:
		has_shoulder_changed = true
		check_shoulder()

# Custom

func change_alignment() -> void:
	if has_shoulder_changed:
		if is_right_shoulder:
			spring_length = lerpf(spring_length, -MAX_INNER_SPRING_LENGTH, SHOULDER_LERP_WEIGHT)
			if is_equal_approx(spring_length, -MAX_INNER_SPRING_LENGTH):
				print_debug("Entered when left shoulder spring length value was: " + str(spring_length))
				has_shoulder_changed = false
		if !is_right_shoulder:
			spring_length = lerpf(spring_length, MAX_INNER_SPRING_LENGTH, SHOULDER_LERP_WEIGHT)
			if is_equal_approx(spring_length, MAX_INNER_SPRING_LENGTH):
				print_debug("Entered when right shoulder spring length value was: " + str(spring_length))
				has_shoulder_changed = false

func change_alignment_with_tween() -> void:
	pass


func check_shoulder() -> void:
	print_debug("Checking shoulder")
	if is_equal_approx(spring_length, MAX_INNER_SPRING_LENGTH):
		print_debug("It's the right shoulder")
		is_right_shoulder = true
	if is_equal_approx(spring_length, -MAX_INNER_SPRING_LENGTH):
		print_debug("It's the left shoulder")
		is_right_shoulder = false
