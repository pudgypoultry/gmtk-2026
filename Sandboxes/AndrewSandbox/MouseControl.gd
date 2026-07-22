extends MarginContainer

enum State { PREPARING, READY, RECORDING, DONE }

@export_category("Game Rules")
@export var max_tracking_time : float = 0.3

@export_category("Plugging in Nodes")
@export var mouse_start_position : Control
@export var mouse_tracker : Node

@export_category("Debug")
@export var debug : bool = false

var current_state = State.PREPARING
var mouse_recording = []
var tracking_timer = 0.0


func _process(delta : float) -> void:
	if current_state == State.RECORDING:
		tracking_timer += delta
		record()
		if tracking_timer >= max_tracking_time:
			current_state = State.DONE
			if debug:
				queue_redraw()


func record() -> void:
	var current_pos = get_viewport().get_mouse_position()
	mouse_recording.append(current_pos)
	if debug:
		print(mouse_recording)


func _draw():
	for i in range(len(mouse_recording) - 1):
		print("drawing line: " + str(i))
		draw_line(mouse_recording[i+1], mouse_recording[i], Color.GREEN, -1.0)


func handle_mouse_entered_start():
	if current_state == State.PREPARING:
		current_state = State.READY
		print("hi")


func handle_mouse_exited_start():
	if current_state == State.READY:
		current_state = State.RECORDING
		print("Poop")
