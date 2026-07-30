extends StateManager

func _ready():
	super._ready()
	
func _process(delta):
	super._process(delta)
	
func _physics_process(delta):
	super._physics_process(delta)
	
func on_state_transition(oldState:State, newState:State):
	super.on_state_transition(oldState, newState)
