extends State
# post Draw results state

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	stateManager.results_panel.show()
	# clean up any remaining enemy nodes
	for n in stateManager.enemy_folder.get_children():
		if n is Node3D:
			n.queue_free()
	stateManager.mouse_moved = false
	stateManager.mouse_in_circle = false

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	super.__Exit(newState)
	stateManager.results_panel.hide()
