extends Node3D

const CAM_FOV_INIT : float = 90.0
const CAM_FOV_ADD : float = 20.0
const INNER_MAX_LENGTH : float = 0.9
const OUTER_MAX_LENGTH : float = 2.0
const OUTER_MAX_SPRINT_LENGTH : float = 1.3
const OUTER_MAX_AIM_LENGTH : float = 0.7
const AIM_CHANGE_SPEED : float = 0.2
const SHOULDER_CHANGE_SPEED : float = 0.11
const SPRINT_CHANGE_SPEED : float = 0.5

enum CameraAlignment {
    LEFT, 
    CENTER, 
    RIGHT
    }

enum WalkMode {
    SPRINT,
    WALK
    }

@export var inner_arm : SpringArm3D
@export var outer_arm : SpringArm3D
@export var camera : Camera3D
@export var mouse_y_sensibility : float = 0.005

var cam_fov : float = CAM_FOV_INIT
var cam_fov_sprint : float = cam_fov + CAM_FOV_ADD
var cam_tween : Tween
var inner_arm_tween : Tween
var outer_arm_tween : Tween

# Flags

var cam_is_current : bool = true
var current_alignment : CameraAlignment = CameraAlignment.RIGHT
var current_walk_mode : WalkMode = WalkMode.WALK
var is_aiming_down_sights : bool = false
var has_walk_mode_changed : bool = false
var has_shoulder_changed : bool = false

# Engine

func _ready() -> void:
    camera.make_current()
    camera.fov = cam_fov
    inner_arm.spring_length = INNER_MAX_LENGTH 
    inner_arm.add_excluded_object(owner)
    outer_arm.spring_length = OUTER_MAX_LENGTH
    outer_arm.add_excluded_object(owner)
    print_debug(str(owner) + " has been added as excluded object for outer and inner SpringArm3D")
    GameInput.connect("shoulder_change_triggered", _on_shoulder_change_triggered)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.is_action_pressed("RMB"):
            is_aiming_down_sights = true
        if event.is_action_released("RMB"):
            is_aiming_down_sights = false

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        outer_arm.rotation.x -= event.screen_relative.y * mouse_y_sensibility
        outer_arm.rotation.x = clampf(outer_arm.rotation.x, -PI/3, PI/4)

func _process(_delta: float) -> void:
    check_change_cam_alignment()
    check_aim_down_sights()

# Signals
        
func _on_shoulder_change_triggered() -> void:
    if !has_shoulder_changed:
        has_shoulder_changed = true
        if current_alignment == CameraAlignment.RIGHT:
            set_alignment(CameraAlignment.LEFT)
        else:
            set_alignment(CameraAlignment.RIGHT)
    
func _on_sprint_started() -> void:
    enter_sprint()

func _on_sprint_ended() -> void:
    exit_sprint()

# Custom

func check_aim_down_sights() -> void:
    if current_walk_mode == WalkMode.SPRINT:
        return

    GameGlobals.kill_tween(GameGlobals.TweenKillMode.FINISH_AND_KILL, outer_arm_tween)

    if outer_arm.spring_length != OUTER_MAX_AIM_LENGTH and is_aiming_down_sights:
        outer_arm_tween = outer_arm.create_tween()
        outer_arm_tween.tween_property(outer_arm, "spring_length", OUTER_MAX_AIM_LENGTH, AIM_CHANGE_SPEED)

    if outer_arm.spring_length != OUTER_MAX_LENGTH and !is_aiming_down_sights:
        outer_arm_tween = outer_arm.create_tween()
        outer_arm_tween.tween_property(outer_arm, "spring_length", OUTER_MAX_LENGTH, AIM_CHANGE_SPEED)

func check_change_cam_alignment() -> void:
    if !has_shoulder_changed:
        return

    GameGlobals.kill_tween(GameGlobals.TweenKillMode.FINISH_AND_KILL, inner_arm_tween)

    if current_alignment == CameraAlignment.LEFT:
        inner_arm_tween = inner_arm.create_tween()
        inner_arm_tween.tween_property(inner_arm, "spring_length", -INNER_MAX_LENGTH, SHOULDER_CHANGE_SPEED)
        has_shoulder_changed = false
    if current_alignment == CameraAlignment.RIGHT:
        inner_arm_tween = inner_arm.create_tween()
        inner_arm_tween.tween_property(inner_arm, "spring_length", INNER_MAX_LENGTH, SHOULDER_CHANGE_SPEED)
        has_shoulder_changed = false

## Starts camera sprint animation
func enter_sprint() -> void:
    GameGlobals.kill_tween_group(GameGlobals.TweenKillMode.FINISH_AND_KILL, cam_tween, outer_arm_tween)

    cam_tween = camera.create_tween()
    outer_arm_tween = outer_arm.create_tween()
    cam_tween.tween_property(camera, "fov", cam_fov_sprint, SPRINT_CHANGE_SPEED)
    outer_arm_tween.tween_property(outer_arm, "spring_length", OUTER_MAX_SPRINT_LENGTH, SPRINT_CHANGE_SPEED)

## Ends camera sprint animation
func exit_sprint() -> void:
    GameGlobals.kill_tween_group(GameGlobals.TweenKillMode.FINISH_AND_KILL, cam_tween, outer_arm_tween)

    cam_tween = camera.create_tween()
    outer_arm_tween = outer_arm.create_tween()
    cam_tween.tween_property(camera, "fov", cam_fov, SPRINT_CHANGE_SPEED)
    outer_arm_tween.tween_property(outer_arm, "spring_length", OUTER_MAX_LENGTH, SPRINT_CHANGE_SPEED)

## Sets alignment for arm to assume
func set_alignment(alignment : CameraAlignment) -> void:
    current_alignment = alignment

## Sets walk mode for player
func set_walk_mode(new_walk_mode : WalkMode) -> void:
    current_walk_mode = new_walk_mode


