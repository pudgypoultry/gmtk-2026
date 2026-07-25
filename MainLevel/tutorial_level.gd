extends Node3D

@onready var samurai: SamuraiCtrl = $Samurai
@onready var samurai_master: SamuraiCtrl = $Samurai_Master
@onready var camera_loc_active_game: Marker3D = $CameraLoc_ActiveGame
@onready var camera_loc_menu: Marker3D = $CameraLoc_Menu
@onready var camera_perspective: Camera3D = $"Camera-Perspective"

@onready var main_menu_3d: Node3D = $"Camera-Perspective/MainMenu3D"
@export var playbutton_slice_name:String = "Playoption"


func _ready() -> void:
	__delayed_setup.call_deferred()
	
func __delayed_setup() -> void:
	var loc:Vector3 = samurai.position
	samurai_master.head_look_at(loc)
	camera_perspective.position = camera_loc_menu.position
	main_menu_3d.camera_slicer.sliced_obj.connect(on_sliced_obj)
	
func on_sliced_obj(name:String) -> void:
	if name == playbutton_slice_name:
		move_camera(false)

func move_camera(menu_active:bool) -> void:
	var loc:Vector3 = Vector3.ZERO
	if menu_active:
		loc = camera_loc_menu.position
	else:
		loc = camera_loc_active_game.position
	var tween = get_tree().create_tween()
	tween.tween_property(camera_perspective, "position", loc, 1.0)
	#tween.tween_callback(### advance game function goes hear)
