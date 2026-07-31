extends StateManager
@export_category("Game Rules")
@export var countdown_time_limit: float = 4.0
@export var original_waiting_time: float = 0.7
@export var reaction_time_limit: float = 0.5
@export var post_draw_time_limit: float = 2.0

@export_category("Plugging in Nodes")
@export var mouse_ctrl: MouseControl
@export var countdown_label: Countdown_Label
@export var enemy_folder: Node3D
@export var results_panel : Panel

@export_category("Enemy Spawner")
# Array of Packed SliceableObject Scenes
@export var enemy_list: Array[PackedScene]
@export var spawn_points: Array[Marker3D]

var selected_enemy: SliceableObject
var mouse_moved:bool = false
var mouse_in_circle:bool = false
var current_score:int = 0
var win_streak:int = 0

@onready var slice_draw: State = $SliceDraw

func _ready():
	super._ready()
	mouse_ctrl.mouse_ready.connect(__on_mouse_ready)
	mouse_ctrl.mouse_left.connect(__on_mouse_left)
	mouse_ctrl.done_slicing.connect(__on_done_slicing)

func __on_mouse_ready() -> void:
	mouse_moved = false
	mouse_in_circle = true
	
func __on_mouse_left() -> void:
	mouse_moved = true
	mouse_in_circle = false
	
func __on_done_slicing(how_many : int) -> void:
	current_score += how_many
	if currentState == slice_draw:
		win_streak += 1
		currentState.NextState()

func reset_slicer() -> void:
	mouse_ctrl.clean_up()
	countdown_label.stop()
	currentState.ChangeState(initialState)
	
func on_state_transition(oldState:SimpleState, newState:SimpleState):
	super.on_state_transition(oldState, newState)
	print("State transisiton ", oldState.name, " to ", newState.name)
