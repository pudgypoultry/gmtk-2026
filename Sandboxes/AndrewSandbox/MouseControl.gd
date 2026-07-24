extends CanvasLayer
class_name MouseControl

enum State { PREPARING, READY, RECORDING, DONE }

@export_category("Game Rules")
@export var max_tracking_time : float = 1.25
@export var direction_debounce_samples : int = 3
@export var min_line_length : float = 50.0

@export_category("Plugging in Nodes")
@export var mouse_start_position : Control
@export var slash_line : PackedScene
@export var margin_child : MarginContainer
@export var camera_slicer : CameraSlicer

@export_category("Debug")
@export var debug : bool = false

var current_state : State = State.PREPARING
var mouse_recording : Array = []
var tracking_timer : float = 0.0


func _process(delta : float) -> void:
	if Input.is_action_just_pressed("R"):
		get_tree().reload_current_scene()
	if current_state == State.RECORDING:
		tracking_timer += delta
		record()
		if tracking_timer >= max_tracking_time:
			current_state = State.DONE
			if debug:
				margin_child.queue_redraw()
			find_lines()


func record() -> void:
	var current_pos = get_viewport().get_mouse_position()
	mouse_recording.append(current_pos)


func find_lines() -> void:
	var current_breakpoint = 0
	var lines = {}
	var line_order = []
	
	var confirmed_x_dir = 1
	var confirmed_y_dir = 1
	var has_confirmed_x = false
	var has_confirmed_y = false
	
	var candidate_x_dir = 1
	var candidate_x_run = 0
	var candidate_x_start = 0
	
	var candidate_y_dir = 1
	var candidate_y_run = 0
	var candidate_y_start = 0
	
	for i in range(1, len(mouse_recording)):
		var last_pos = mouse_recording[i - 1]
		var current_pos = mouse_recording[i]
		
		# --- X axis debounce ---
		if current_pos.x != last_pos.x:
			var x_dir = find_direction(last_pos.x, current_pos.x)
			if x_dir == candidate_x_dir:
				candidate_x_run += 1
			else:
				candidate_x_dir = x_dir
				candidate_x_run = 1
				candidate_x_start = i
			
			if candidate_x_run >= direction_debounce_samples:
				if not has_confirmed_x:
					confirmed_x_dir = candidate_x_dir
					has_confirmed_x = true
				elif candidate_x_dir != confirmed_x_dir:
					line_order.append(mouse_recording[current_breakpoint])
					lines[mouse_recording[current_breakpoint]] = mouse_recording[candidate_x_start]
					current_breakpoint = candidate_x_start
					confirmed_x_dir = candidate_x_dir
					#print("Confirmed x direction change at ", candidate_x_start)
		
		# --- Y axis debounce ---
		if current_pos.y != last_pos.y:
			var y_dir = find_direction(last_pos.y, current_pos.y)
			if y_dir == candidate_y_dir:
				candidate_y_run += 1
			else:
				candidate_y_dir = y_dir
				candidate_y_run = 1
				candidate_y_start = i
			
			if candidate_y_run >= direction_debounce_samples:
				if not has_confirmed_y:
					confirmed_y_dir = candidate_y_dir
					has_confirmed_y = true
				elif candidate_y_dir != confirmed_y_dir:
					line_order.append(mouse_recording[current_breakpoint])
					lines[mouse_recording[current_breakpoint]] = mouse_recording[candidate_y_start]
					current_breakpoint = candidate_y_start
					confirmed_y_dir = candidate_y_dir
					#print("Confirmed y direction change at ", candidate_y_start)
	
	# If no changes found, take whole line
	print("Number of found lines: ", len(lines.keys()))
	if len(lines.keys()) == 0:
		line_order.append(mouse_recording[0])
		lines[mouse_recording[0]] = mouse_recording[len(mouse_recording) - 1]
	else:
		line_order.append(mouse_recording[current_breakpoint])
		lines[mouse_recording[current_breakpoint]] = mouse_recording[len(mouse_recording) - 1]
	
	var lines_to_delete = []
	for line : Vector2 in lines.keys():
		if line.distance_to(lines[line]) < min_line_length:
			lines_to_delete.append(line)
	
	for line in lines_to_delete:
		lines.erase(line)
		line_order.erase(line)
	
	var line_set = []
	print("Line order: ", line_order)
	for line in line_order:
		if line in line_set:
			continue
		print("TIME TO SLICE: ", line)
		var new_slash : SlashLine = slash_line.instantiate()
		new_slash.prepare(line, lines[line])
		margin_child.add_child(new_slash)
		await camera_slicer.perform_slice(new_slash.points[0], new_slash.points[1])
		line_set.append(line)


func find_direction(from, to):
	if to - from == 0:
		return 1
	return (to - from) / abs(to - from)


func handle_mouse_entered_start():
	if current_state == State.PREPARING:
		current_state = State.READY


func handle_mouse_exited_start():
	if current_state == State.READY:
		current_state = State.RECORDING
