extends State
# state for while the player is waiting for the countdown
var countdown_timer:float = 0.0

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	countdown_timer = 0.0
	stateManager.countdown_label.show()
	stateManager.countdown_label.countdown()
	if stateManager.mouse_ctrl.samurai: 
		stateManager.mouse_ctrl.samurai.slice_ready()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	stateManager.countdown_label.hide()
	super.__Exit(newState)

func FailState() -> void:
	super.FailState()
	stateManager.reset_slicer()

func Update(delta) -> void:
	super.Update(delta)
	countdown_timer += delta
	if stateManager.mouse_moved:
		self.FailState()
		return
	if countdown_timer > stateManager.countdown_time_limit:
		self.NextState()
