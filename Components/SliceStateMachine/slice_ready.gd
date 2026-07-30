extends State
# state for setting up slicer before the mouse enters the start area

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	stateManager.mouse_moved = false
	stateManager.mouse_in_circle = false
	stateManager.current_score = 0
	stateManager.results_panel.hide()
	# instantiate a random enemy
	stateManager.selected_enemy = stateManager.enemy_list.pick_random().instantiate()
	# select a random spawn point
	var selected_spawn_point: Marker3D = stateManager.spawn_points.pick_random()
	stateManager.selected_enemy.position = selected_spawn_point.position
	stateManager.selected_enemy.basis = selected_spawn_point.basis
	stateManager.enemy_folder.add_child(stateManager.selected_enemy)

func Update(delta) -> void:
	super.Update(delta)
	if stateManager.mouse_in_circle:
		self.NextState()
