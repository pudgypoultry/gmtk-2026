extends Node
class_name DuelManager

#enum MState {PREPARING, COUNTDOWN, WAITING, DRAW, RESULTS}

@export_category("Game Rules")
@export var delay_start_base : float = 0.75
@export var countdown_time : float = 4.0
@export var original_waiting_time : float = 0.7
@export var reaction_time_max : float = 0.4
@export var enemy_scenes : Array[PackedScene]


@export_category("Plugging in Nodes")
@export var enemy_folder : Node3D
@export var mouse_control : MouseControl
@onready var countdown_label: Control = $countdown_label
@export var results_panel : Panel

@export_category("Debug")
@export var debug = false

var current_state : MState = MState.PREPARING
var countdown_timer : float = 0.0
var waiting_timer : float = 0.0
var waiting_time : float
var reaction_timer : float = 0.0
var time_taken : float = 0.0
var current_enemies : Array[SliceableObject] = []
var mouse_moved : bool = false
var mouse_in_circle : bool = false
var current_score : int = 0
var has_performed_debug_spawn : bool = false
var how_fast : float = 0.0
var duel_is_setup : bool = false
var win_streak : int = 0

signal changed_state(state : State)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_circle = false
	mouse_moved = false
	waiting_time = original_waiting_time
	mouse_control.connect("mouse_ready", handle_mouse_ready)
	mouse_control.connect("mouse_left", handle_mouse_left)
	mouse_control.connect("done_slicing", handle_done_slicing)
# Called every frame. 'delta' is the elapsed time since the previous frame.


# Pass this function a dictionary of enemy packedscene keys and Vector3 positions
func prepare_duel(enemy : PackedScene):
	print("Preparing Duel")
	mouse_moved = false
	waiting_time = original_waiting_time
	var next_enemy : SliceableObject = enemy.instantiate()
	enemy_folder.add_child(next_enemy)
	current_enemies.append(next_enemy)
	next_enemy.position.x += randf_range(-3.0, 3.0)
	next_enemy.scale *= randf_range(0.8, 1.5)
	duel_is_setup = true


func begin_countdown():
	print("Starting Countdown")
	current_state = MState.COUNTDOWN
	changed_state.emit(current_state)
	countdown_label.countdown()


func check_duel_end():
	current_state = MState.RESULTS
	changed_state.emit(current_state)
	if not mouse_moved:
		lose_duel()
	# allow for extra time after slice to watch
	await get_tree().create_timer(2.0).timeout
	end_duel()


func end_duel():
	if current_score == 0:
		lose_duel()
		return
	win_duel()


func win_duel():
	print("YOU WIN")
	print("How fast:	", how_fast)
	print("How many things were cut:	", current_score)
	win_streak += 1
	results_panel.set_results(current_score, how_fast, win_streak)
	print("Current win streak:	", win_streak)
	# Show end of battle screen
	# Show go to next fight screen


func lose_duel():
	print("YOU LOSE")
	# Kill player
	# Show lose screen
	# Offer go back to start


func reset_duel():
	how_fast = 0.0
	current_score = 0
	mouse_moved = false
	mouse_in_circle = false
	current_enemies = []
	current_state = MState.PREPARING
	countdown_timer = 0.0
	waiting_timer = 0.0
	waiting_time = original_waiting_time
	reaction_timer = 0.0
	time_taken = 0.0
	duel_is_setup = false
	mouse_control.clean_up()


func handle_mouse_ready():
	mouse_in_circle = true
	mouse_moved = false


func handle_mouse_left():
	mouse_in_circle = false
	mouse_moved = true


func handle_done_slicing(how_many : int):
	current_score = how_many
