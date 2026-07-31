extends SimpleState

var tracking_timer:float

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	tracking_timer = 0.0
	stateManager.sword_image_rect.texture = stateManager.sword_open_image
	stateManager.mouse_ctrl.mouse_left.emit()

func __Exit(newState:SimpleState) -> void:
	super.__Exit(newState)
	stateManager.sword_image_rect.texture = stateManager.sword_closed_image

func Update(delta) -> void:
	super.Update(delta)
	tracking_timer += delta
	var current_pos = get_viewport().get_mouse_position()
	stateManager.mouse_recording.append(current_pos)
	if tracking_timer >= stateManager.mouse_ctrl.max_tracking_time:
		self.NextState()
