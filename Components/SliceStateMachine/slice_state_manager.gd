extends StateManager
@export_category("Game Rules")
@export var countdown_time_limit: float = 4.0
@export var original_waiting_time: float = 0.7
@export var reaction_time_limit: float = 0.5
@export var post_draw_time_limit: float = 2.0

@export_category("Mouse Control")
@export var mouse_ctrl:MouseControl
@export var mouse_start_position : Control
@export var slash_line : PackedScene
@export var margin_child : MarginContainer
@export var sword_image_rect : TextureRect
@export var sword_closed_image : Texture2D
@export var sword_open_image : Texture2D
@export var preparing_state: SimpleState
@export var ready_state: SimpleState

@export_category("Plugging in Nodes")
@export var countdown_label: Countdown_Label
@export var enemy_folder: Node3D
@export var results_panel : Panel

@export_category("Enemy Spawner")
# Array of Packed SliceableObject Scenes
@export var enemy_list: Array[PackedScene]
@export var spawn_points: Array[Marker3D]
@export var deterministic:bool = false
@export var deterministic_selection:int = 0

var selected_enemy: Node3D
var mouse_moved:bool = false
var mouse_in_circle:bool = false
var current_score:int = 0
var win_streak:int = 0
var how_fast : float = 0
var mouse_recording : Array = []

@onready var slice_draw: State = $SliceDraw

@warning_ignore("unused_signal")
signal reset_machine

func _ready():
	super._ready()
	for child in get_children():
		if child is State:
			child.set_slicer_ui.connect(set_slicer_visibility)
			child.stateManager = self
	reset_machine.connect(initialState._on_go_next)
	# TESTING HERE
	_on_duel_start()

func set_slicer_visibility(visable:bool):
	if visable:
		margin_child.show()
	else:
		margin_child.hide()

func __on_mouse_ready() -> void:
	mouse_moved = false
	mouse_in_circle = true
	
func __on_mouse_left() -> void:
	mouse_moved = true
	mouse_in_circle = false

func _on_mouse_start_position_mouse_entered() -> void:
	if currentState == preparing_state:
		currentState.NextState()

func _on_mouse_start_position_mouse_exited() -> void:
	if currentState == ready_state:
		currentState.NextState()

func __on_done_slicing(how_many : int) -> void:
	current_score += how_many
	win_streak += 1
	currentState.NextState()

func _on_duel_start():
	reset_machine.emit()

func reset_slicer() -> void:
	print("Reset Slicer")
	countdown_label.stop()
	currentState.ChangeState(initialState)
	# don't need to clean up since this is done by the results state
	# passed and failed runs will run through the results state
	#for n in enemy_folder.get_children():
		#if n is Node3D:
			#n.queue_free()

func start_slicer() -> void:
	currentState.NextState()

func on_state_transition(oldState:SimpleState, newState:SimpleState):
	super.on_state_transition(oldState, newState)
	print("State transisiton ", oldState.name, " to ", newState.name)
