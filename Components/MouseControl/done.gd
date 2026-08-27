extends State

var how_many_sliced_objects : int = 0
var line_set = []

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	how_many_sliced_objects = 0
	line_set = []
	if stateManager.mouse_ctrl.debug:
		stateManager.margin_child.queue_redraw()
	find_lines()


func __Exit(newState:SimpleState) -> void:
	super.__Exit(newState)


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
	
	for i in range(1, len(stateManager.mouse_recording)):
		var last_pos = stateManager.mouse_recording[i - 1]
		var current_pos = stateManager.mouse_recording[i]
		
		# --- X axis debounce ---
		if current_pos.x != last_pos.x:
			var x_dir = find_direction(last_pos.x, current_pos.x)
			if x_dir == candidate_x_dir:
				candidate_x_run += 1
			else:
				candidate_x_dir = x_dir
				candidate_x_run = 1
				candidate_x_start = i
			
			if candidate_x_run >= stateManager.mouse_ctrl.direction_debounce_samples:
				if not has_confirmed_x:
					confirmed_x_dir = candidate_x_dir
					has_confirmed_x = true
				elif candidate_x_dir != confirmed_x_dir:
					line_order.append(stateManager.mouse_recording[current_breakpoint])
					lines[stateManager.mouse_recording[current_breakpoint]] = stateManager.mouse_recording[candidate_x_start]
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
			
			if candidate_y_run >= stateManager.mouse_ctrl.direction_debounce_samples:
				if not has_confirmed_y:
					confirmed_y_dir = candidate_y_dir
					has_confirmed_y = true
				elif candidate_y_dir != confirmed_y_dir:
					line_order.append(stateManager.mouse_recording[current_breakpoint])
					lines[stateManager.mouse_recording[current_breakpoint]] = stateManager.mouse_recording[candidate_y_start]
					current_breakpoint = candidate_y_start
					confirmed_y_dir = candidate_y_dir
					#print("Confirmed y direction change at ", candidate_y_start)
	
	# If no changes found, take whole line
	print("Number of found lines: ", len(lines.keys()))
	if len(lines.keys()) == 0:
		line_order.append(stateManager.mouse_recording[0])
		lines[stateManager.mouse_recording[0]] = stateManager.mouse_recording[len(stateManager.mouse_recording) - 1]
	else:
		line_order.append(stateManager.mouse_recording[current_breakpoint])
		lines[stateManager.mouse_recording[current_breakpoint]] = stateManager.mouse_recording[len(stateManager.mouse_recording) - 1]
	
	var lines_to_delete = []
	for line : Vector2 in lines.keys():
		if line.distance_to(lines[line]) < stateManager.mouse_ctrl.min_line_length:
			lines_to_delete.append(line)
	
	for line in lines_to_delete:
		lines.erase(line)
		line_order.erase(line)
	
	print("Line order: ", line_order)
	for line in line_order:
		if line in line_set:
			continue
		#print("TIME TO SLICE: ", line)
		var new_slash : SlashLine = stateManager.slash_line.instantiate()
		if line not in lines.keys():
			continue
		new_slash.prepare(line, lines[line])
		stateManager.margin_child.add_child(new_slash)
		await stateManager.slicer.camera_slicer.perform_slice(new_slash.points[0], new_slash.points[1])
		line_set.append(new_slash)
		
	for object in stateManager.slicer.camera_slicer.sliced_object_array:
		if object:
			object.finish_slice()
			how_many_sliced_objects += 1
	
	print("I'm cut in half real bad")
	stateManager.__on_done_slicing(how_many_sliced_objects)
	#stateManager.mouse_ctrl.done_slicing.emit(how_many_sliced_objects)

func find_direction(from, to):
	if to - from == 0:
		return 1
	return (to - from) / abs(to - from)
