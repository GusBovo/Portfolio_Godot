class_name CharacterMovingObject
extends CharacterBody2D

const REACH_FLOOR_SPEED = 500

@export var has_entered_character_body : bool = false
@export var can_fly : bool = false

func make_object_ready(character_body : CharacterBody2D, 
rigid_body_reference : RigidBody2D, 
body_can_fly : bool = false):
	can_fly = body_can_fly
	
	rigid_body_reference.hide()
	rigid_body_reference.process_mode = Node.PROCESS_MODE_DISABLED
	
	character_body.input_pickable = true

# This is called on _physics_process()
func execute_character_movement(speed : int, 
sprite) -> void:
	if !is_on_floor() and !can_fly:
		velocity.y = REACH_FLOOR_SPEED
	if sprite is AnimatedSprite2D:
		sprite.play("walking")
	elif sprite is Sprite2D:
		pass
	else:
		print_debug("NOT A SPRITE!!!")
	if speed:
		velocity.x = speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func execute_on_mouse_entered_signal() -> void:
	has_entered_character_body = true
	#print("entered ", str(self))

func execute_on_mouse_exited_signal() -> void:
	has_entered_character_body = false
	#print("exited ", str(self))
