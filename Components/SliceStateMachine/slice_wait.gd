extends State

func __Enter(oldState:SimpleState) -> void:
	stateManager.mouse_start_position.hide()
	stateManager.mouse_ctrl.hide()
	if stateManager.slicer.samurai:
		stateManager.slicer.samurai.standing()
	super.__Enter(oldState)

func __Exit(newState:SimpleState) -> void:
	stateManager.mouse_ctrl.show()
	super.__Exit(newState)
# needs to just wait for a signal and then transition to SliceReady
func _on_go_next():
	NextState()
