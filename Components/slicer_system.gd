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

@export_category("Enemy Spawner")
# Array of Packed SliceableObject Scenes
@export var enemy_list: Array[PackedScene]
@export var spawn_points: Array[Marker3D]
