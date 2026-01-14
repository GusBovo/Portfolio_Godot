extends Motion

func _enter_state() -> void:
    print_debug(name)

func _update_state(delta : float) -> void:
    calculate_gravity(delta)
    calculate_velocity(SPRINT_SPEED, direction, delta)

    if not is_falling(): 
        if GameInput.shift.is_pressed:
            state_finished.emit("Sprint")
            return
            
        sprint_ended.emit()
        state_finished.emit("Idle")