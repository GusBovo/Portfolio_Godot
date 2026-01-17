extends RayCast2D

const MAX_ZOOM : Vector2 = Vector2(0.43, 0.43)

var current_zoom : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	zoom_camera()

func zoom_camera() -> void:
	if self.collide_with_bodies and get_collider() != null:
		#print_debug("something collided: ", get_collider())
		if get_collider() is RigidBody2D:
			#print_debug("that something is a confirmed RigidBody2D")
			#if get_collider().is_in_group("is_on_scale"):
			current_zoom = get_parent().zoom
			if current_zoom >= MAX_ZOOM:
				#print_debug("zoom IS not equal MAX ZOOM... yet")
				get_parent().zoom = current_zoom - Vector2(0.1, 0.1)
				get_parent().offset.y -= 60 
			else:
				print_debug("zoom is equal MAX ZOOM")
				pass
