extends Motion

func _enter_state() -> void:
    print_debug(name)

func _update_state(delta : float) -> void:
    calculate_gravity(delta)
    calculate_velocity(SPEED, direction, delta)

    if not is_falling():
        state_finished.emit("Idle")