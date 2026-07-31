extends Node3D

@export_category("Plugging in Nodes")
@export var samurai: SamuraiCtrl
@export var master_static: Node3D
@export var camera_perspective: Camera3D
@export var sub_viewport_container: SubViewportContainer
@export var camera_loc_active_game: Marker3D
@export var camera_loc_menu: Marker3D
@export var camera_loc_credits: Marker3D
@export var camera_loc_settings: Marker3D
@export var game_theme_player: AudioStreamPlayer
@export var ambience_player: AudioStreamPlayer
@export var tutorial_dialogue: DialogueCtrl
@export var main_menu: Panel
@export var mouse_ctrl:MouseControl
@export var slice_state_manager: StateManager

enum cameraloc {Play, Menu, Settings, Credits}
var slice_goal:int = 0

func _ready() -> void:
	camera_perspective.position = camera_loc_menu.position
	
func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("Menu"):
		#main_menu._on_return_pressed()
		#tutorial_dialogue.hide()
		#game_theme_player.play()
	if samurai.record:
		var mouse_pos = get_viewport().get_mouse_position()
		var world_pos = camera_perspective.project_position(mouse_pos, 3.2)
		samurai.set_ik_target_pos(world_pos)

func move_camera(pos:cameraloc) -> void:
	var loc:Vector3 = Vector3.ZERO
	var bas:Basis
	var tween = get_tree().create_tween()
	if pos == cameraloc.Menu:
		loc = camera_loc_menu.position
		bas = camera_loc_menu.basis
	elif pos == cameraloc.Play:
		loc = camera_loc_active_game.position
		bas = camera_loc_active_game.basis
		tween.finished.connect(tutorial_dialogue.show)
		tween.finished.connect(sub_viewport_container.show)
	elif pos == cameraloc.Settings:
		loc = camera_loc_settings.position
		bas = camera_loc_settings.basis
	else:
		loc = camera_loc_credits.position
		bas = camera_loc_credits.basis
		
	tween.tween_property(camera_perspective, "position", loc, 1.0)
	tween.parallel().tween_property(camera_perspective, "basis", bas, 1.0)


func _on_main_menu_menu_changed(state: GlobalVars.MenuChange) -> void:
	match (state):
		GlobalVars.MenuChange.Menu:
			tutorial_dialogue.hide()
			move_camera(cameraloc.Menu)
		GlobalVars.MenuChange.Play:
			tutorial_dialogue.show()
			move_camera(cameraloc.Play)
		GlobalVars.MenuChange.Settings:
			tutorial_dialogue.hide()
			move_camera(cameraloc.Settings)
		GlobalVars.MenuChange.Credits:
			tutorial_dialogue.hide()
			move_camera(cameraloc.Credits)
		GlobalVars.MenuChange.Quit:
			get_tree().quit()
	
func show_slicer() -> void:
	game_theme_player.stop()
	ambience_player.play()
	mouse_ctrl.show()

func hide_slicer() -> void:
	mouse_ctrl.clean_up()
	mouse_ctrl.hide()
	ambience_player.stop()
	game_theme_player.play()
	slice_state_manager.reset_slicer()

func on_done_slicing(how_many:int) -> void:
	if how_many >= slice_goal:
		tutorial_dialogue.Next()
	else:
		tutorial_dialogue.Fail()
	hide_slicer()

func _on_tutorial_dialogue_done() -> void:
	master_static.play_animation()

func _on_tutorial_dialogue_slice_param_update(enemy_selection: int, goal: int) -> void:
	if enemy_selection != -1:
		slice_state_manager.deterministic = true
		slice_state_manager.deterministic_selection = enemy_selection
	else:
		slice_state_manager.deterministic = false
	self.slice_goal = goal
