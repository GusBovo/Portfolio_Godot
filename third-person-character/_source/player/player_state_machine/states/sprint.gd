extends Motion

func _enter_state() -> void:
    sprint_started.emit()
    print_debug(name)

func _state_input(event : InputEvent) -> void:
    if event.is_action_pressed("Space"):
        state_finished.emit("SprintJump")

func _update_state(delta : float) -> void:
    set_direction()
    calculate_velocity(SPRINT_SPEED, direction, delta)

    if not GameInput.shift.is_pressed or direction == Vector3.ZERO:
        sprint_ended.emit()
        state_finished.emit("Walk")

    if is_falling():
        state_finished.emit("SprintFall")