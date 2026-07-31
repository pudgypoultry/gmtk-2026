extends SimpleState

# next state is triggered by mouse event
func __Enter(oldState:SimpleState) -> void:
	super.__Enter(oldState)
	if stateManager.mouse_ctrl.samurai: stateManager.mouse_ctrl.samurai.slice_ready()
