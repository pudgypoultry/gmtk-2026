extends State
# state for while the player is waiting for the countdown
var countdown_timer:float = 0.0
var last_state:SimpleState

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	last_state = oldState
	super.__Enter(oldState)
	countdown_timer = 0.0
	stateManager.slicer.countdown_label.show()
	stateManager.slicer.countdown_label.countdown()
	if stateManager.slicer.samurai: 
		stateManager.slicer.samurai.slice_ready()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	stateManager.slicer.stop_countdown()
	super.__Exit(newState)

#func FailState() -> void:
	#super.FailState()
	#stateManager.reset_slicer()

func Update(delta) -> void:
	super.Update(delta)
	countdown_timer += delta
	if stateManager.mouse_moved:
		#self.FailState()
		ChangeState(last_state)
		return
	if countdown_timer > stateManager.slicer.countdown_time_limit:
		self.NextState()
