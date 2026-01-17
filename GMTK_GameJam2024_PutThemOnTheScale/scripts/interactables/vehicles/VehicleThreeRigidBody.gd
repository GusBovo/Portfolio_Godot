extends RigidMovingObject

# Here is where RigidBody2D property changes will occur, if any
# Properties to change:

const OBJECT_WEIGHT : float = 1.5

# Here is the template code available to every interactable RigidBody2D:

func _ready() -> void:
	make_object_ready(self)

func _physics_process(_delta: float) -> void:
	grab_object(self)
	remove_from_game(self)

func _on_mouse_entered() -> void:
	execute_on_mouse_entered_signal()

func _on_mouse_exited() -> void:
	execute_on_mouse_exited_signal()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Vehicle Area2D entered by ", body)
	execute_body_entered_on_area2d_signal(self, body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("Vehicle Area2D exited by ", body)
	execute_body_exited_on_area2d_signal(body)
