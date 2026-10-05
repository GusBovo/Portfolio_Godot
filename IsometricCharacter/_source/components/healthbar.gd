extends Node

@onready var health_label = $CurrentHealthLabel
@onready var max_health_label = $MaxHealthLabel
@onready var progress_bar = $ProgressBar

# Engine Methods

# Script Methods

func change_health(health_amount : int, max_health_amount : int) -> void:
	health_label.text = str(health_amount)
	@warning_ignore("integer_division")
	progress_bar.value = (health_amount * 100) / max_health_amount

func change_max_health(max_health_amount : int) -> void:
	max_health_label.text = str(max_health_amount)
