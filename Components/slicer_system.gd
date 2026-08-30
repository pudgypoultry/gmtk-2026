extends Node
class_name Slicer

@export_category("Plugging in Nodes")
@export var camera_slicer : CameraSlicer
@export var countdown_label: Countdown_Label
@export var enemy_folder: Node3D
@export var state_manager: StateManager
@export var mouse_control: MouseControl
@export var results_panel: Panel

@export_category("Optional Nodes")
@export var samurai: SamuraiCtrl

@export_category("Game Rules")
@export var countdown_time_limit: float = 4.0
@export var original_waiting_time: float = 0.7
@export var reaction_time_limit: float = 0.5
@export var post_draw_time_limit: float = 2.0
@export var win_slices:int = 1
@export var loop:bool = true
@export var show_results:bool = true

@export_category("Enemy Spawner")
# Array of Packed SliceableObject Scenes
@export var enemy_list: Array[PackedScene]
@export var spawn_points: Array[Marker3D]

@export_category("Debug")
@export var sandbox_debug:bool = false

@warning_ignore("unused_signal")
signal slice_fail(current_state:SimpleState)
@warning_ignore("unused_signal")
signal slice_pass(current_state:SimpleState)

func start_slicer() -> void:
	state_manager._on_duel_start()

func stop_slicer() -> void:
	state_manager.reset_slicer()

func _unhandled_input(event):
	# TESTING
	if GlobalVars.DEBUG and sandbox_debug and event.is_action_pressed("ui_accept"):
		state_manager._on_duel_start()
		get_viewport().set_input_as_handled()
