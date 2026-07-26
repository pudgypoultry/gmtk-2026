extends Node

enum State {PREPARING, COUNTDOWN, WAITING, DRAW, RESULTS}

@export_category("Game Rules")
@export var delay_start_base : float = 0.75
@export var countdown_time : float = 4.0
@export var original_waiting_time : float = 0.7
@export var reaction_time_max : float = 0.4
@export var test_dict : Dictionary[Vector3, PackedScene]


@export_category("Plugging in Nodes")
@export var enemy_folder : Node3D
@export var camera_slicer : CameraSlicer
@export var mouse_control : MouseControl
@export var countdown_sound : AudioStreamPlayer3D
@export var draw_sound : AudioStreamPlayer3D
@export var grade_sound : AudioStreamPlayer3D
@export var draw_text : Control
@onready var countdown_label: Control = $countdown_label

@export_category("Debug")
@export var debug = false

var current_state : State = State.PREPARING
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
var win_streak : int = 0.0

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
func _process(delta: float) -> void:
	if current_state == State.PREPARING:
		if !has_performed_debug_spawn && debug:
			has_performed_debug_spawn = true
			prepare_duel(test_dict)
		if mouse_in_circle:
			begin_countdown()
	
	if current_state == State.COUNTDOWN:
		countdown_timer += delta
		if mouse_moved:
			lose_duel()
		if countdown_timer > countdown_time:
			var random_count_add = randf_range(0.75, 3.75)
			waiting_time += random_count_add
			current_state = State.WAITING
			changed_state.emit(current_state)
	
	if current_state == State.WAITING:
		waiting_timer += delta
		if mouse_moved:
			lose_duel()
		if waiting_timer > waiting_time:
			countdown_label.countend()
			draw_sound.play()
			current_state = State.DRAW
			changed_state.emit(current_state)
	
	if current_state == State.DRAW:
		reaction_timer += delta
		if mouse_moved && how_fast == 0.0:
			how_fast = reaction_timer
		if reaction_timer > reaction_time_max or how_fast != 0.0:
			check_duel_end()


# Pass this function a dictionary of enemy packedscene keys and Vector3 positions
func prepare_duel(positions : Dictionary):
	print("Preparing Duel")
	mouse_moved = false
	waiting_time = original_waiting_time
	for pos : Vector3 in positions.keys():
		var next_enemy : SliceableObject = positions[pos].instantiate()
		enemy_folder.add_child(next_enemy)
		current_enemies.append(next_enemy)
		next_enemy.position = pos


func begin_countdown():
	print("Starting Countdown")
	current_state = State.COUNTDOWN
	changed_state.emit(current_state)
	countdown_sound.play()
	countdown_label.countdown()


func check_duel_end():
	current_state = State.RESULTS
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
	current_state = State.PREPARING
	countdown_timer = 0.0
	waiting_timer = 0.0
	waiting_time = original_waiting_time
	reaction_timer = 0.0
	time_taken = 0.0


func handle_mouse_ready():
	mouse_in_circle = true
	mouse_moved = false


func handle_mouse_left():
	mouse_in_circle = false
	mouse_moved = true


func handle_done_slicing(how_many : int):
	current_score = how_many
