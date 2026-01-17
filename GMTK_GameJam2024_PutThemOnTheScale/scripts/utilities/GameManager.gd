extends Node

const SECONDS_FOR_TIMER : float = 60.0
const OBJECT_ARRAY : Array[String] = [
	"res://scenes/objects/interactables/Woodchest.tscn",
]
const VEHICLE_OBJECT_ARRAY : Array[String] = [
	"res://scenes/objects/interactables/VehicleOne.tscn",
	"res://scenes/objects/interactables/VehicleTwo.tscn",
	"res://scenes/objects/interactables/VehicleThree.tscn",
	"res://scenes/objects/interactables/VehicleFour.tscn",
	"res://scenes/objects/interactables/VehicleFive.tscn",
]
const PEOPLE_OBJECT_ARRAY : Array[String] = [
	"res://scenes/objects/interactables/NPCMan.tscn"
]

var game_finished : bool = false
var random_number_gen : RandomNumberGenerator
var last_weight_added : float
var last_weight_removed : float
var weight : float

signal weight_added
signal weight_removed
signal end_the_game(final_weight : float)

func _ready() -> void:
	# CREATING AND ADDING SEED TO RANDOM NUM GEN
	random_number_gen = RandomNumberGenerator.new()
	random_number_gen.randomize()

# RELATED TO SPAWNING AND REMOVING FROM THE GAME:
func despawn_object(body : Node):
	# Third check to see if body is not on scale group
	# (other two made by objects themselves)
	if not body.is_in_group("is_on_scale"):
		#print("Is body on scale? ", str(body.is_in_group("is_on_scale")))
		body.queue_free()
	#print("Deleted")

func spawn_object(object_type : String, 
spawner_reference : Area2D,
spawn_global_position: Vector2, 
is_flying_spawner : bool,
is_right_spawner : bool
) -> void:
	# DEFINETELY GOING TO BUG
	if object_type == "people":
		var object_instance = spawn_helper(object_type, is_flying_spawner)
		if is_right_spawner:
			#print("people spawner check in Game Manager, it is on the right side")
			if object_instance.get_node("./AnimatedSprite2D") is AnimatedSprite2D:
				object_instance.get_node("./AnimatedSprite2D").flip_h = true
			elif object_instance.get_node("./Sprite2D") is Sprite2D:
				object_instance.get_node("./Sprite2D").global_scale = Vector2(-1,1)
			else:
				print_debug("Object has no sprite2d or animatedsprite2d in right spawn")
			object_instance.speed = -object_instance.speed
			#print("people spawn should have updated instance in Game Manager to appear on the right side")
			#print("people spawner check in Game Manager, it is on the left side")
		object_instance.global_position = spawn_global_position
		#print("people spawn should have updated instance in Game Manager to appear on the left side")
		spawner_reference.get_parent().add_child(object_instance)
		#print("adding instance of people to game in Game Manager")
	if object_type == "vehicle":
		var object_instance = spawn_helper(object_type, is_flying_spawner)
		if is_right_spawner:
			#print("vehicle spawner check in Game Manager, it is on the right side")
			object_instance.global_scale = Vector2(-1,1)
			object_instance.speed = -object_instance.speed
			#print("vehicle spawn should have updated instance in Game Manager to appear on the right side")
			#print("vehicle spawner check in Game Manager, it is on the left side")
		object_instance.global_position = spawn_global_position
		#print("vehicle spawn should have updated instance in Game Manager to appear on the left side")
		spawner_reference.get_parent().add_child(object_instance)
		#print("adding instance of vehicle to game in Game Manager")

# Complex function to either instance a node based on object_type, or
# in case of flying spawner and node not able to fly
# try instantiate again until node can fly
func spawn_helper(object_type : String, is_flying_spawner : bool) -> Node2D:
	#print("spawn helper activated in Game Manager")
	var random_number
	var object_scene
	if object_type == "people":
		random_number = random_number_gen.randi_range(0, PEOPLE_OBJECT_ARRAY.size() - 1)
		object_scene = load(PEOPLE_OBJECT_ARRAY[random_number]) as PackedScene
	elif object_type == "vehicle":
		random_number = random_number_gen.randi_range(0, VEHICLE_OBJECT_ARRAY.size() - 1)
		object_scene = load(VEHICLE_OBJECT_ARRAY[random_number]) as PackedScene
	else:
		print_debug("OBJECT_TYPE NOT MATCHING IN SPAWN HELPER ON GAME MANAGER")
	
	 
	var object_instance = object_scene.instantiate()
	#print("spawner is flying? ", is_flying_spawner,"\nobject instantiate in Game Manager can fly? ", object_instance.can_fly)
	if is_flying_spawner and not object_instance.can_fly:
		while not object_instance.can_fly:
			#print("let's free it then")
			object_instance.queue_free()
			if object_type == "people":
				random_number = random_number_gen.randi_range(0, PEOPLE_OBJECT_ARRAY.size() - 1)
				object_scene = load(PEOPLE_OBJECT_ARRAY[random_number]) as PackedScene
			elif object_type == "vehicle":
				random_number = random_number_gen.randi_range(0, VEHICLE_OBJECT_ARRAY.size() - 1)
				object_scene = load(VEHICLE_OBJECT_ARRAY[random_number]) as PackedScene
			else:
				print_debug("OBJECT_TYPE NOT MATCHING IN SPAWN HELPER WHILE LOOP ON GAME MANAGER... BREAKING FROM IT")
				break
			object_instance = object_scene.instantiate()
			#print("and generete another...\n can it fly now? ", object_instance.can_fly)
		#print("returning object instance to spawn object function in Game Manager")
		return object_instance
	#print("returning object instance to spawn object function in Game Manager")
	return object_instance

# RELATED TO WEIGHT SCALE:
func add_weight_on_scale(body : RigidBody2D, body_weight : float) -> void:
	if body.is_in_group("is_on_scale"):
		last_weight_added = weight
		weight += body_weight
		if weight == last_weight_added + body_weight:
			weight_added.emit()
			#print("weight added emitted on GameManager")

func remove_weight_on_scale(body : RigidBody2D, body_weight : float) -> void:
	if !body.is_in_group("is_on_scale"):
		last_weight_removed = weight
		weight -= body_weight
		if weight == last_weight_removed - body_weight:
			weight_removed.emit()
			#print("weight removed emitted on GameManager")

func update_scale_display(label : Label) -> void:
	label.text = "Weight on scale: " + str(weight)

# NOT BEING USED
func check_if_body_is_on_scale(body : Node2D) -> void:
	if body is not StaticBody2D:
		#print("passed finish game check body")
		#print(body, "is on scale group? ", body.is_in_group("is_on_scale"))
		if body.is_in_group("is_on_scale"):
			end_the_game.emit(weight)
			print_debug("you have finished the game")
