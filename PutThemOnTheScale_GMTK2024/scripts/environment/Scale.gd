extends StaticBody2D

# The scale needs to detect the object added or the weight added by it somehow
# What if every object propagated a simple is_on_scale() signal?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("is_on_scale", true)
	#print("group ", get_groups(), " created with Scale")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("is_on_scale"):
		body.add_to_group("is_on_scale")
