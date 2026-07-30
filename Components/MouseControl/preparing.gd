extends SimpleState

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	stateManager.mouse_recording = []
	stateManager.sword_image_rect.texture = stateManager.sword_closed_image
	stateManager.margin_child.clean_up()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	super.__Exit(newState)
	stateManager.mouse_ctrl.mouse_ready.emit()
