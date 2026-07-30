extends State

func __Enter(oldState:State) -> void:
	# called when the state is entered
	super.__Enter(oldState)

func __Exit(newState:State) -> void:
	# called when the state is exited
	super.__Exit(newState)

func Update(delta) -> void:
	super.Update(delta)

func PhysicsUpdate(delta) -> void:
	super.PhysicsUpdate(delta)
