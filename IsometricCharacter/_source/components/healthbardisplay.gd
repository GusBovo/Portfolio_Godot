extends Node3D

signal health_changed
signal max_health_changed

@onready var health_bar = $HeathBarViewport/HealthBar
@onready var progress_bar = $HeathBarViewport/HealthBar/ProgressBar

func _ready() -> void:
	connect("health_changed", _on_health_changed)
	connect("max_health_changed", _on_max_health_changed)

# Signal Methods

func _on_health_changed(amount : int, max_amount : int) -> void:
	health_bar.change_health(amount, max_amount)

func _on_max_health_changed(amount : int):
	if amount < 100:
		push_error("WARNING: " + str(owner) + " emitted max health below 100 to health bar")
	health_bar.change_max_health(amount)
