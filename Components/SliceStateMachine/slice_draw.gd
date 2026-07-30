extends State
# state for the Draw
var reaction_timer:float
var how_fast:float

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	reaction_timer = 0.0
	how_fast = 0.0
	stateManager.countdown_label.countend()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	super.__Exit(newState)
	stateManager.results_panel.set_results(stateManager.current_score, how_fast, stateManager.win_streak)

func Update(delta) -> void:
	super.Update(delta)
	reaction_timer += delta
	if stateManager.mouse_moved && how_fast == 0.0:
		how_fast = reaction_timer
	if reaction_timer > stateManager.reaction_time_limit or how_fast != 0.0:
		if not stateManager.mouse_moved or stateManager.current_score == 0:
			self.FailState()
			return
