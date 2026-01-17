extends CharacterBody2D

const SPEED = 200.0

var has_entered_character_body : bool = false

signal stopped_processing

func _ready():
	$RigidBody2D.hide()
	$RigidBody2D.process_mode = Node.PROCESS_MODE_DISABLED
	self.stopped_processing.connect(_on_stopped_processing)
	self.input_pickable = true

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and has_entered_character_body:
		#print("left mouse button pressed")
		self.stopped_processing.emit()

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	if SPEED:
		velocity.x = SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_stopped_processing() -> void:
	#print("characterbody2d stopped processing")
	var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
	$CollisionShape2D.hide()
	$RigidBody2D.process_mode = Node.PROCESS_MODE_PAUSABLE
	self.remove_child(animated_sprite)
	$RigidBody2D.add_child(animated_sprite)
	$RigidBody2D.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	$RigidBody2D.input_pickable = true
	$RigidBody2D.contact_monitor = true
	$RigidBody2D.max_contacts_reported = 1
	$RigidBody2D.show()
	#print("activated rigidbody2d")
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _on_mouse_entered() -> void:
	has_entered_character_body = true
	#print("entered ", str(self))

func _on_mouse_exited() -> void:
	has_entered_character_body = false
	#print("exited ", str(self))
