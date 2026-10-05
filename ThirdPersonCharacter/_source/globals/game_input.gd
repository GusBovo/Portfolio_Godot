extends Node

const KEYS = preload("res://_source/globals/keyboard_constants.gd")

const input_actions_map : Array[StringName] = [
	"up",
	"down",
	"left",
	"right",
	"jump",
	"sprint",
	"interact",
	"aim",
    "shoot"
]

var input_struct_map : Array[Dictionary]

var shift : Dictionary = {
	is_pressed = false,

}
var rmb : Dictionary[Variant, bool] = {
	is_pressed = false,
}

# Flags

var is_listening_to_key = false

# Signals

signal shoulder_change_triggered

# Engine

func _input(event: InputEvent) -> void:
	_game_input(event)

	if event.is_action_pressed("Shift"):
		print_debug("Shift being pressed!")
		shift.is_pressed = true
	if event.is_action_released("Shift"):
		shift.is_pressed = false

	if event.is_action_pressed("RMB"):
		rmb.is_pressed = true
	if event.is_action_released("RMB"):
		rmb.is_pressed = false

	if event is InputEventKey:
		if not event.is_echo():
			if Input.is_physical_key_pressed(Key.KEY_T):
				print_debug(event.as_text_physical_keycode())
		

func _unhandled_input(event: InputEvent) -> void:
	_game_unhandled_input(event)

	if event is InputEventMouseButton:
		if event.is_action_pressed("LMB"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.is_action_pressed("MB1"):
			emit_signal("shoulder_change_triggered")
	
	if event is InputEventKey and event.is_action_pressed("ESC"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	if is_listening_to_key:
		_listen_to_physical_key()

# Custom

func _check_event_is_joypad(event : InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		pass
	
	return

func _check_event_is_key(event : InputEvent) -> void:
	if event is InputEventKey:
		pass
	
	return

func _check_event_is_mouse(event : InputEvent) -> void:
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		pass
	
	return

## Calls get_viewport().set_input_as_handled() in GameInput
func _consume_input_event() -> void:
	get_viewport().set_input_as_handled()

func _create_input_struct_map() -> void:
	for action : StringName in input_actions_map:
		input_struct_map.append({
			action_name = action,
			is_held = false,
			time_held = 0.0
			})

func _game_input(_event : InputEvent) -> void:
	return

func _game_unhandled_input(_event : InputEvent) -> void:
	return

func _hold(event : InputEvent) -> float:
	return 1.0

func _is_held(event : InputEvent) -> bool:
	return true

func _listen_to_physical_key() -> Key:
	for key in KEYS.PhysicalKeys.values():
		if Input.is_physical_key_pressed(key):
			is_listening_to_key = false
			print_debug("Key pressed is: " + str(key))
			return key
	return Key.KEY_NONE
