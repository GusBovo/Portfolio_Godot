extends Area3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var is_hammering : bool = false

func _ready() -> void:
	animation_player.play("at_ready")
	area_entered.connect(_on_hammer_area_entered)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_echo():
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if is_hammering:
				return
			is_hammering = true
			#print_debug("Executed")
			animation_player.play("hammering")
			await animation_player.animation_finished
			animation_player.play("at_ready")
			await animation_player.animation_finished
			is_hammering = false

func _physics_process(_delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var camera := get_viewport().get_camera_3d()
	
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_direction := camera.project_ray_normal(mouse_pos)
	
	var plane = Plane(Vector3.UP, 1.85)
	var world_pos = plane.intersects_ray(ray_origin, ray_direction)
	
	if world_pos:
		self.position = world_pos
	
	#print_debug("Hammer position: " + str(self.position))

func _on_hammer_area_entered(area : Area3D) -> void:
	if area.is_in_group("Target"):
		print_debug(area.name + " was hitted by hammer")
		area.hit_target()
