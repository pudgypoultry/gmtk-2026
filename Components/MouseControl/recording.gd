extends SimpleState

var tracking_timer:float

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	tracking_timer = 0.0

func Update(delta) -> void:
	super.Update(delta)
	tracking_timer += delta
	var current_pos = get_viewport().get_mouse_position()
	stateManager.mouse_recording.append(current_pos)
	if tracking_timer >= stateManager.mouse_ctrl.max_tracking_time:
		self.NextState()
