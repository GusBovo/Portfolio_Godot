extends Motion

func _enter_state() -> void:
    print_debug(name)
    jump()

func _update_state(delta : float) -> void:
    calculate_gravity(delta)
    calculate_velocity(SPEED, direction, delta)

    if velocity.y <= 0:
        state_finished.emit("Fall")

func jump() -> void:
    velocity.y = JUMP_VELOCITY