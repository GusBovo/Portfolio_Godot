extends Node

# LIMITS

# # CAOS
const CAOS_MAX_LIMIT : int = 999999999999999999 # 999 quatrilhões
const CAOS_MIN_LIMIT : int = 0

var current_caos : int = 0

# # STRESS
const STRESS_MAX_LIMIT : int = 100
const STRESS_MIN_LIMIT : int = 0

var current_stress : int = 0

# # Destruction
var combo_multiplier : float = 0.0

# Caos
func set_caos(caos_amount : int) -> void:
	assert(caos_amount >= 0, "set_caos() caos_amount is negative: " + str(caos_amount))
	if caos_amount <= 0:
		return
	current_caos = mini(current_caos + caos_amount, CAOS_MAX_LIMIT)

# Stress
func set_stress(stress_amount : int) -> void:
	current_stress = clampi(current_stress + stress_amount, STRESS_MIN_LIMIT, STRESS_MAX_LIMIT)

# Destruction
func calculate_caos_amount(base_amount : float):
	set_caos(roundi(base_amount * combo_multiplier))
