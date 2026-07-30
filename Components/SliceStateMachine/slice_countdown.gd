extends State
# state for while the player is waiting for the countdown
var countdown_timer:float = 0.0

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	countdown_timer = 0.0
	stateManager.countdown_label.countdown()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	super.__Exit(newState)

func Update(delta) -> void:
	super.Update(delta)
	countdown_timer += delta
	if stateManager.mouse_moved:
		self.FailState()
		return
	if countdown_timer > stateManager.countdown_time_limit:
		self.NextState()

func PhysicsUpdate(delta) -> void:
	super.PhysicsUpdate(delta)
