extends State

signal aiming_down_sights

func _enter_state() -> void:
    aiming_down_sights.emit()

