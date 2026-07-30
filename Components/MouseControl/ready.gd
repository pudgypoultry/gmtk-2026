extends SimpleState

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	super.__Exit(newState)
	stateManager.sword_image_rect.texture = stateManager.sword_open_image
	stateManager.mouse_ctrl.mouse_left.emit()
