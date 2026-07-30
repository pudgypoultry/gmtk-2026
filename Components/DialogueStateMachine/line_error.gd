extends Dialogue_Line_State

var return_state:Dialogue_Line_State

func __Enter(oldState:State) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	return_state = oldState

func NextState() -> void:
	self.ChangeState(return_state)
