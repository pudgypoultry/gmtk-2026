extends Node3D

@onready var samurai: SamuraiCtrl = $Samurai
@onready var samurai_master: SamuraiCtrl = $Samurai_Master
@onready var camera_loc_active_game: Marker3D = $CameraLoc_ActiveGame
@onready var camera_loc_menu: Marker3D = $CameraLoc_Menu
@onready var camera_perspective: Camera3D = $"Camera-Perspective"
@onready var camera_loc_credits: Marker3D = $CameraLoc_credits
@onready var camera_loc_settings: Marker3D = $CameraLoc_settings
enum cameraloc {Play, Menu, Settings, Credits}

@onready var main_menu_3d: Node3D = $"Camera-Perspective/MainMenu3D"
@export var slice_delay:float = 0.5
@export var play_button_slice_name:String = "play_option"
@export var settings_button_slice_name:String = "settings_option"
@export var credits_button_slice_name:String = "credits_option"
@export var quit_button_slice_name:String = "quit_option"

@onready var tutorial_dialogue: DialogueCtrl = $TutorialDialogue


func _ready() -> void:
	__delayed_setup.call_deferred()
	
func __delayed_setup() -> void:
	var loc:Vector3 = samurai.position
	samurai_master.head_look_at(loc)
	camera_perspective.position = camera_loc_menu.position
	main_menu_3d.camera_slicer.sliced_obj.connect(on_sliced_obj)
	
func on_sliced_obj(name:String) -> void:
	if name == play_button_slice_name:
		await get_tree().create_timer(slice_delay).timeout
		main_menu_3d.disable_menu()
		move_camera(cameraloc.Play)
	elif name == quit_button_slice_name:
		await get_tree().create_timer(slice_delay).timeout
		get_tree().quit()
	elif name == settings_button_slice_name:
		await get_tree().create_timer(slice_delay).timeout
		main_menu_3d.disable_menu()
		move_camera(cameraloc.Settings)
	elif name == credits_button_slice_name:
		await get_tree().create_timer(slice_delay).timeout
		main_menu_3d.disable_menu()
		move_camera(cameraloc.Credits)

func move_camera(pos:cameraloc) -> void:
	var loc:Vector3 = Vector3.ZERO
	var bas:Basis
	var tween = get_tree().create_tween()
	if pos == cameraloc.Menu:
		loc = camera_loc_menu.position
		bas = camera_loc_menu.basis
		tween.tween_callback(main_menu_3d.enable_menu)
	elif pos == cameraloc.Play:
		loc = camera_loc_active_game.position
		bas = camera_loc_active_game.basis
		tween.finished.connect(tutorial_dialogue.show_dialogue)
	elif pos == cameraloc.Settings:
		loc = camera_loc_settings.position
		bas = camera_loc_settings.basis
		tween.tween_callback(main_menu_3d.enable_settings)
	else:
		loc = camera_loc_credits.position
		bas = camera_loc_credits.basis
		tween.tween_callback(main_menu_3d.enable_credits)
		
	tween.tween_property(camera_perspective, "position", loc, 1.0)
	tween.tween_property(camera_perspective, "basis", bas, 1.0)
	
