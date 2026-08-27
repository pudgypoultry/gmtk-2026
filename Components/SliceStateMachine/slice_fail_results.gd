extends State
# post Draw results state

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	stateManager.slicer.results_panel.set_results(stateManager.current_score, stateManager.how_fast, stateManager.win_streak)
	stateManager.slicer.results_panel.show()
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
