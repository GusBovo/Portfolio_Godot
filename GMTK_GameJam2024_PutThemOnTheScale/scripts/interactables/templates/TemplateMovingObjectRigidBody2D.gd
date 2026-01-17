extends RigidBody2D

# REMEMBER TO MAKE A COPY OF THE SCENE AND THE SCRIPT, 
# DON'T ATTACH THE FIRST TO ANOTHER SCENE OR THE SECOND
# TO ANOTHER NODE

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


# Here is the template code available to every interactable RigidBody2D:

var grabbing_object : bool = false
var can_grab : bool = true
var mouse_detected : bool = false
var weighted : bool = false

func _ready() -> void:
	self.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	self.input_pickable = true
	self.contact_monitor = true
	self.max_contacts_reported = 1

func _physics_process(_delta: float) -> void:
	if mouse_detected:
		grab_object()

func grab_object() -> void:
	#print("entered grab_object")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_grab:
		#print("passed left_mouse_button_pressed grab_object")
		#print("left mouse button pressed in ", str(self))
		if !self.freeze:
			self.freeze = true
			#print("frozen")
		if !grabbing_object:
			grabbing_object = true
			#print("grabbed")
		#is_grabbing_object.emit()
		$"..".global_transform.origin = get_global_mouse_position()
		#print("set global tranform origin")
	else:
		#print("else = passed here")
		if grabbing_object:
			grabbing_object = false
		if self.freeze:
			self.freeze = false
		if Input.is_action_just_released("shoot"):
			can_grab = false

# TODO Need to add fix for Collision detecting and adding to is_on_scale
# group, even if not in the same collision layer
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("is_on_scale"):
		#print("Entered ", str(body))
		if !grabbing_object:
			if !weighted:
				self.add_to_group("is_on_scale")
				GameManager.add_weight_on_scale(self, self.mass)
				weighted = true
				#print(GameManager.weight)
				#print("Added ", str(self), " to scale group")
			#else:
				#print("has been weighted")


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("is_on_scale"):
		#print("Exited ", str(body))
		if self.is_in_group("is_on_scale"):
			if weighted:
				self.remove_from_group("is_on_scale")
				GameManager.remove_weight_on_scale(self, self.mass)
				weighted = false
				#print(GameManager.weight)
				#print("Removed ", str(self), " from scale group")


func _on_mouse_entered() -> void:
	#print("mouse detected in ", str(self))
	mouse_detected = true

func _on_mouse_exited() -> void:
	#print("mouse exiting ", str(self))
	if mouse_detected and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_detected = false
