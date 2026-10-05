class_name RigidStaticObject
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

# Okay, some TODO ideas:
# - Need to update code to not let objects go through important 
#   Collision shapes (like walls and floor, maybe buildings, scale floor 
#   collision, other objects in the scale, avoiding objects outside scale)
# - Need to consider the force applied to objects on the scale if a object the 
#   player is grabbing collides with they
# - Need to think of a solution to not let mouse button event be captured after
#   clicking an object


# One time only bool, need to confirm object is grab able
# used mainly to avoid further conflict down the line and to 
# reduce game scope
var can_be_grabbed : bool = true :
	set(value):
		can_be_grabbed = value
	get:
		return can_be_grabbed
# Bool to check if mouse entered this object
@export var is_mouse_inside_object : bool = false
# Probably checks if object weight has been added to scale
# Yeah, it does precisely that...
var weighted : bool = false :
	set(value):
		weighted = value
	get:
		return weighted

# Signal made for a three way decision making
signal third_party(this_body : Node2D, body_that_entered : Node2D)

func make_object_ready(rigid_body : RigidBody2D) -> void:
	# Setting up static rigid body 
	rigid_body.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	rigid_body.input_pickable = true
	# Might not need this after implementing body:
	rigid_body.contact_monitor = true
	rigid_body.max_contacts_reported = 1

# Changes collision layer and mask from 4 to 5...
func change_collision_layer_and_mask(rigid_body : RigidBody2D) -> void:
	# Should have changed current layer and mask from object
	# (no matter what they were) to whatever the object needed 
	# to set it to
	# But yeah, pickable objects only needs to change from 4 to 5 
	if not rigid_body.get_collision_layer_value(5):
		if not rigid_body.get_collision_mask_value(5):
			rigid_body.set_collision_layer_value(4, false)
			rigid_body.set_collision_mask_value(4, false)
			rigid_body.set_collision_layer_value(5, true)
			rigid_body.set_collision_mask_value(5, true)
			#print("Changed collision layer and mask")

# Should allow the current object to be 'grabbed'
# or, actually, follow the mouse global position
func grab_object(rigid_body : RigidBody2D) -> void:
	# Confirms mouse has entered object
	if is_mouse_inside_object:
		#print("Mouse is inside ", rigid_body)
		# Also confirms if the object can be grabbed - again, only one time
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#print("Pressed left mouse button, can you grab ", rigid_body, "? ", can_be_grabbed)
			if can_be_grabbed:
				# Changes layer and mask immediatly after
				#print("Passed to layers")
				change_collision_layer_and_mask(rigid_body)
				# Freezes the rigid body to stop physics, 
				# but collision still works
				#print("passed to freeze")
				if !rigid_body.freeze:
					rigid_body.freeze = true
					#print("Confirmed ", rigid_body," is not frozen, but has it been freezed now? ", rigid_body.freeze)
				# Set rigidbody global transform origin to the global mouse position
				#print("passed to transform")
				rigid_body.global_transform.origin = get_global_mouse_position()
				# Allows rotation of the rigidbody positive and negative by 15 degrees 
				# using mouse wheel up and down
				#print("passed to rotation")
				rotate_object(rigid_body)
		elif Input.is_action_just_released("shoot"):
			# Unfreezes body, making it functional again
			if rigid_body.freeze:
				rigid_body.freeze = false
				#print("Confirmed ", rigid_body," is frozen, but has it been unfrozen now? ", rigid_body.freeze)
			if can_be_grabbed:
				can_be_grabbed = false

# Here is what it should do:
# If the body checked can't be grabbed, is weighted and belongs to
# is on scale group, this should add itself to the group and weight itself
# that is... after checking if this is weighted, has been added to group 
# and can't be grabbed
func execute_body_entered_on_area2d_signal(rigid_body : RigidBody2D, body : Node) -> void:
	#print("passed execute body entered on area 2d")
	if body is not StaticBody2D:
		#print("body is rigidbody2d")
		# Checks if the body that entered can't be grabbed 
		if !body.can_be_grabbed:
			#print("body can't be grabbed anymore")
			# Check if body that entered is on scale group
			if body.is_in_group("is_on_scale"):
				#print("body is on scale")
				# Checks if body that entered has been weighted
				if body.weighted:
					#print("body has been weighted")
					# Checks if this object can be grabbed
					if !rigid_body.can_be_grabbed:
						#print("rigidbody cant be grabbed")
						# Checks if this body is on scale group
						if !rigid_body.is_in_group("is_on_scale"):
							add_to_group("is_on_scale")
							#print("rigidbody wasn't on scale, but it is now? ", rigid_body.is_in_group("is_on_scale"))
							# Checks if this object has been weighted
							if !weighted:
								#print("rigidbody has not been weighted")
								GameManager.add_weight_on_scale(rigid_body, rigid_body.OBJECT_WEIGHT)
								weighted = true
								#print("rigidbody now has been weighted")
			elif !body.is_in_group("is_on_scale"):
				#print("body is not on scale")
				if rigid_body.is_in_group("is_on_scale"):
					body.add_to_group("is_on_scale")
					#print("body now has been added to group? ", body.is_in_group("is_on_scale"))
					if !body.weighted:
						GameManager.add_weight_on_scale(body, body.OBJECT_WEIGHT)
						body.weighted = true
						#print("body has been weighted")

# This should:
# Check if the body that left is weighted, if it is on scale group, 
# and if it can't be grabbed first
func execute_body_exited_on_area2d_signal(body : Node) -> void:
	if body == RigidBody2D:
		# Checks if the body that entered can't be grabbed
		if not body.can_be_grabbed:
			# Then checks if this body that entered is on scale
			if body.is_in_group("is_on_scale"):
				# Then checks if it is weighted
				if body.weighted:
					# Now makes the same check for this object
					if not can_be_grabbed: 
						if is_in_group("is_on_scale"):
							if weighted:
								third_party.emit(self, body)

func execute_on_mouse_entered_signal() -> void:
	#print("mouse detected in ", str(self))
	
	# Not assigning value without need now -- change
	if !is_mouse_inside_object:
		is_mouse_inside_object = true

func execute_on_mouse_exited_signal() -> void:
	#print("mouse exiting ", str(self))
	
	# Problematic, avoids problems with mouse faster than generated frame,
	# but might be used wrong with this name
	if is_mouse_inside_object and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_mouse_inside_object = false

# The problematic
func remove_from_game(rigid_body : Node2D) -> void:
	# Checks if this object can be grabbed
	if !rigid_body.can_be_grabbed:
		# Checks if the object is on scale group
		if !is_in_group("is_on_scale"):
			# If both are false, activates 2 second timer
			# This timer pauses when game is paused (I hope, at least)
			get_tree().create_timer(2.0, false, true, false).timeout.connect(
				# Connects signal and calls anonymous function
				func () -> void:
					# Checks once again if it is not on scale group before deleting
					if !is_in_group("is_on_scale"):
						# Calls Game Manager object deletion,
						# which should check ONCE MORE 
						# if object is not on scale group
						GameManager.despawn_object(rigid_body)
			)

func rotate_object(rigid_body) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		rigid_body.rotation_degrees += 15
	elif Input.is_action_just_pressed("scroll_down"):
		rigid_body.rotation_degrees -= 15
