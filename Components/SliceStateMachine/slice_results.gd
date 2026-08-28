extends State
# post Draw results state

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	if stateManager.current_score < stateManager.slicer.win_slices:
		FailState()
		return
	stateManager.slicer.slice_pass.emit(self)
	stateManager.slicer.results_panel.set_results(stateManager.current_score, stateManager.how_fast, stateManager.win_streak)
	if stateManager.slicer.show_results: stateManager.slicer.results_panel.show()
	stateManager.mouse_start_position.hide()
	# clean up any remaining enemy nodes
	for n in stateManager.slicer.enemy_folder.get_children():
		if n is Node3D:
			n.queue_free()
	stateManager.mouse_moved = false
	stateManager.mouse_in_circle = false

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	stateManager.slicer.results_panel.hide()
	super.__Exit(newState)
