class_name StateMachine
extends Node

@export var start_state : State
var state_map : Dictionary
var current_state : State = null
var _is_state_active : bool = false :
	set = _set_active

# Engine

func _ready() -> void:
	_create_state_map()
	_initialize_state(start_state)

func _input(event: InputEvent) -> void:
	current_state._state_input(event)

func _physics_process(delta: float) -> void:
	current_state._update_state(delta)

# Custom

func _create_state_map() -> void:
	for child : State in get_children():
		child.state_finished.connect(_change_state)
		state_map[child.name] = child

func _initialize_state(state: State) -> void:
	_set_active(true)
	current_state = state
	current_state._enter_state()

func _change_state(state_name : String) -> void:
	if not _is_state_active:
		return
	
	current_state._exit_state()
	current_state = state_map[state_name]
	current_state._enter_state()

func _set_active(value : bool) -> void:
	_is_state_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _is_state_active:
		current_state = null
