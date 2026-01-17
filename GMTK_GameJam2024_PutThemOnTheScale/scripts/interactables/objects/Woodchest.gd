extends RigidStaticObject

# REMEMBER TO SET Z_INDEX 

# Hard lesson learned...
# Never try to change a RigidBody2D with global_position property
# only global_transform.origin
# Weirdly enough, if you change with global_position and
# set a print() to keep track of global_postion updates
# the RigidBody2D will actually update in game...

# Will have to make the grab a one time thing to not mess with physics of 
# stacked objects. Pretty sad. But we gotta do what we gotta do.
# Will be using object_grabed bool for that

# Okay, some TODO ideas:
# - Need to update code to not let objects go through important 
#   Collision shapes (like walls and floor, maybe buildings, scale floor 
#   collision, other objects in the scale, avoiding objects outside scale)
# - Need to consider the force applied to objects on the scale if a object the 
#   player is grabbing collides with they
# - Need to think of a solution to not let mouse button event be captured after
#   clicking an object

# Here is where RigidBody2D property changes will occur, if any
# Properties to change:
const OBJECT_WEIGHT : float = 2.0

# Here is the template code available to every interactable RigidBody2D:

#var grabbing_object : bool = false
#var can_grab : bool = true
#var mouse_detected : bool = false
#var weighted : bool = false

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
	#print("Woodchest Area2D entered by ", body)
	execute_body_entered_on_area2d_signal(self, body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("Woodchest Area2D exited by ", body)
	execute_body_exited_on_area2d_signal(body)
