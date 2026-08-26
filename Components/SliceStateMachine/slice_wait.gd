extends State

# needs to just wait for a signal and then transition to SliceReady

#func _ready():
	#stateManager.reset_machine.connect(_on_go_next)

func _on_go_next():
	NextState()
