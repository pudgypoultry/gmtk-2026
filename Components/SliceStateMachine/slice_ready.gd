extends State
# state for setting up slicer before the mouse enters the start area

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	stateManager.mouse_recording = []
	stateManager.sword_image_rect.texture = stateManager.sword_closed_image
	stateManager.margin_child.clean_up()
	stateManager.mouse_moved = false
	stateManager.mouse_in_circle = false
	stateManager.current_score = 0
	stateManager.how_fast = 0.0
	stateManager.slicer.results_panel.hide()
	stateManager.slicer.countdown_label.hide()
	stateManager.mouse_start_position.show()
	# instantiate an enemy
	stateManager.selected_enemy = stateManager.slicer.enemy_list.pick_random().instantiate()
	# select a random spawn point
	var selected_spawn_point: Marker3D = stateManager.slicer.spawn_points.pick_random()
	# move selected enemy to spawn point
	#stateManager.selected_enemy.position = selected_spawn_point.position
	#stateManager.selected_enemy.basis = selected_spawn_point.basis
	# move enemy folder to spawn point
	stateManager.slicer.camera_slicer.rigidbody_parent.position = selected_spawn_point.position
	stateManager.slicer.camera_slicer.rigidbody_parent.basis = selected_spawn_point.basis
	stateManager.slicer.enemy_folder.add_child(stateManager.selected_enemy)

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	super.__Exit(newState)
	stateManager.mouse_ctrl.mouse_ready.emit()

func Update(delta) -> void:
	super.Update(delta)
	if stateManager.mouse_in_circle:
		self.NextState()
