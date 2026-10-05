extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"..".third_party.connect(_on_ask_third_party_opinion)

# This should be a question sent to a third party, to decide either to remove or
# keep one of the parties in the group
func _on_ask_third_party_opinion(first_party: Node2D, second_party : Node2D) -> void:
	var touching_body
	# First thing is to check this is not processed by itself
	if first_party != get_parent():
		# Second thing is to check if one of the nodes is touching this
		touching_body = body_entered.connect(func(body : Node2D) -> Node2D:
			return body
			)
		if first_party != touching_body:
			if first_party.is_in_group("is_on_scale"):
				first_party.remove_from_group("is_on_scale")
				if first_party.weighted:
					GameManager.remove_weight_on_scale(first_party, first_party.OBJECT_WEIGHT)
					first_party.weighted = false
		if second_party != touching_body:
			if second_party.is_in_group("is_on_scale"):
				second_party.remove_from_group("is_on_scale")
				if second_party.weighted:
					GameManager.remove_weight_on_scale(second_party, second_party.OBJECT_WEIGHT)
					second_party.weighted = false
