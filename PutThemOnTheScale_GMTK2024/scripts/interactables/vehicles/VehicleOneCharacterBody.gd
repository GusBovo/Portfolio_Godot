extends CharacterMovingObject

var speed = 190
var body_can_fly : bool = false

signal stopped_processing

func _ready():
	self.z_index = 3
	self.z_as_relative = false
	make_object_ready(self, $RigidBody2D, body_can_fly)
	stopped_processing.connect(_on_stopped_processing.bind($".", 
		$RigidBody2D, 
		$CollisionShape2D, 
		$Sprite2D))

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and has_entered_character_body:
		#print("left mouse button pressed")
		stopped_processing.emit()

func _physics_process(_delta: float) -> void:
	execute_character_movement(speed, $Sprite2D)

func _on_mouse_entered() -> void:
	execute_on_mouse_entered_signal()

func _on_mouse_exited() -> void:
	execute_on_mouse_exited_signal()

func _on_stopped_processing(character_body : CharacterBody2D, 
rigid_body : RigidBody2D, 
character_collision : CollisionShape2D,
sprite) -> void:
	#print("characterbody2d stopped processing")
	character_collision.hide()
	rigid_body.process_mode = Node.PROCESS_MODE_PAUSABLE
	if sprite is AnimatedSprite2D:
		character_body.remove_child(sprite)
		rigid_body.add_child(sprite)
	elif sprite is Sprite2D:
		character_body.remove_child(sprite)
		rigid_body.add_child(sprite)
	rigid_body.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	rigid_body.input_pickable = true
	rigid_body.contact_monitor = true
	rigid_body.max_contacts_reported = 1
	rigid_body.z_index = 5
	rigid_body.z_as_relative = false
	rigid_body.show()
	#print("activated rigidbody2d")
	character_body.process_mode = Node.PROCESS_MODE_DISABLED
