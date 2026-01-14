extends Motion

func _enter_state() -> void:
    print_debug(name)

func _state_input(event : InputEvent) -> void:
    if event.is_action_pressed("Space"):
        state_finished.emit("Jump")

func _update_state(delta : float) -> void:
    set_direction()
    calculate_velocity(SPEED, direction, delta)

    if GameInput.shift.is_pressed:
        state_finished.emit("Sprint")

    if direction == Vector3.ZERO:
        state_finished.emit("Idle")

    if is_falling():
        state_finished.emit("Fall")
