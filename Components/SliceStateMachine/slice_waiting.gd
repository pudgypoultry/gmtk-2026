extends State
# state for after the countdown has finished, but before the Draw
var waiting_time_limit:float
var waiting_timer:float

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	waiting_time_limit = stateManager.original_waiting_time
	waiting_timer = 0.0
	waiting_time_limit += randf_range(0.75, 3.75)
	stateManager.countdown_label.show()
	stateManager.countdown_label.wait()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	stateManager.countdown_label.hide()
	super.__Exit(newState)

#func FailState() -> void:
	#super.FailState()
	#stateManager.reset_slicer()

func Update(delta) -> void:
	super.Update(delta)
	waiting_timer += delta
	if stateManager.mouse_moved:
		self.FailState()
		return
	if waiting_timer > waiting_time_limit:
			self.NextState()
