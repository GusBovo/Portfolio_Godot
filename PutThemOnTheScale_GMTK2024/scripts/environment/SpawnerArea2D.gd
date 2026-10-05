extends Area2D

# Time for spawn
const VEHICLE_WAIT_TIME : float = 6.0
const PEOPLE_WAIT_TIME : float = 5.4
# Timer variables
var vehicle_timer : Timer = Timer.new()
var people_timer : Timer = Timer.new()
# Game checks
# If right spawner, needs to spawn object inverted in scale and speed
@export var is_right_spawner : bool = false
# If flying, needs to spawn only flying objects
@export var is_flying_spawner : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Setting up timers
	add_child(vehicle_timer)
	add_child(people_timer)
	vehicle_timer.timeout.connect(_on_vehicle_timer_timeout)
	people_timer.timeout.connect(_on_people_timer_timeout)
	vehicle_timer.one_shot = false
	people_timer.one_shot = false


func _process(_delta: float) -> void:
	# Starts both timers
	if vehicle_timer.is_stopped():
		#print("should enable vehicle timer now")
		vehicle_timer.start(VEHICLE_WAIT_TIME)
	if people_timer.is_stopped():
		#print("should enable people timer now")
		people_timer.start(PEOPLE_WAIT_TIME)

func _on_vehicle_timer_timeout() -> void:
	#print("vehicle timer work")
	GameManager.spawn_object("vehicle", self, self.global_position, is_flying_spawner, is_right_spawner)

func _on_people_timer_timeout() -> void:
	#print("people timer work")
	GameManager.spawn_object("people", self, self.global_position, is_flying_spawner, is_right_spawner)
