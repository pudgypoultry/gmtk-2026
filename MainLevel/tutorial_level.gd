extends Node3D

@onready var samurai: SamuraiCtrl = $Samurai
@onready var samurai_master: SamuraiCtrl = $Samurai_Master
@onready var camera_loc_active_game: Marker3D = $CameraLoc_ActiveGame
@onready var camera_loc_menu: Marker3D = $CameraLoc_Menu
@onready var camera_perspective: Camera3D = $"Camera-Perspective"
@onready var camera_loc_credits: Marker3D = $CameraLoc_credits
@onready var camera_loc_settings: Marker3D = $CameraLoc_settings
@onready var game_theme_player: AudioStreamPlayer = $GameThemePlayer

enum cameraloc {Play, Menu, Settings, Credits}

const SLICER_INTERFACE = preload("res://Components/slicer_interface.tscn")
var slicer:Node3D

@onready var tutorial_dialogue: DialogueCtrl = $TutorialDialogue
@onready var main_menu: Panel = $MainMenu

func _ready() -> void:
	__delayed_setup.call_deferred()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		main_menu._on_return_pressed()
		tutorial_dialogue.end_dialogue()
		slicer.queue_free()
		game_theme_player.play()
	if samurai.record:
		var mouse_pos = get_viewport().get_mouse_position()
		var world_pos = camera_perspective.project_position(mouse_pos, 3.2)
		samurai.set_ik_target_pos(world_pos)

func __delayed_setup() -> void:
	var loc:Vector3 = samurai.position
	samurai_master.head_look_at(loc)
	camera_perspective.position = camera_loc_menu.position

func move_camera(pos:cameraloc) -> void:
	var loc:Vector3 = Vector3.ZERO
	var bas:Basis
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	if pos == cameraloc.Menu:
		loc = camera_loc_menu.position
		bas = camera_loc_menu.basis
	elif pos == cameraloc.Play:
		loc = camera_loc_active_game.position
		bas = camera_loc_active_game.basis
		tween.finished.connect(tutorial_dialogue.show_dialogue)
	elif pos == cameraloc.Settings:
		loc = camera_loc_settings.position
		bas = camera_loc_settings.basis
	else:
		loc = camera_loc_credits.position
		bas = camera_loc_credits.basis
		
	tween.tween_property(camera_perspective, "position", loc, 1.0)
	tween.tween_property(camera_perspective, "basis", bas, 1.0)
	

func _on_main_menu_menu_changed(state: GlobalVars.MenuChange) -> void:
	match (state):
		GlobalVars.MenuChange.Menu:
			move_camera(cameraloc.Menu)
		GlobalVars.MenuChange.Play:
			move_camera(cameraloc.Play)
		GlobalVars.MenuChange.Settings:
			move_camera(cameraloc.Settings)
		GlobalVars.MenuChange.Credits:
			move_camera(cameraloc.Credits)
		GlobalVars.MenuChange.Quit:
			get_tree().quit()
			
func init_slice_interface() -> void:
	slicer = SLICER_INTERFACE.instantiate()
	slicer.position = camera_loc_active_game.position
	slicer.basis = camera_loc_active_game.basis
	self.add_child(slicer)
	game_theme_player.stop()
	slicer.mouse_control_canvas.mouse_ready.connect(samurai.slice_ready)
	slicer.mouse_control_canvas.mouse_left.connect(samurai.draw_sword)
	slicer.mouse_control_canvas.done_slicing.connect(samurai.sheath_sword)
