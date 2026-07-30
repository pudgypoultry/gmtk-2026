extends Node

class_name StateManager

@export var initialState : SimpleState
var currentState : SimpleState

func _ready():
	# states are child nodes of the State Manager node
	for child in get_children():
		if child is SimpleState:
			child.Transitioned.connect(on_state_transition)
			child.stateManager = self

	if initialState:
		initialState.ChangeState(initialState)
		currentState = initialState
		print(initialState.name)


func _process(delta):
	if currentState:
		currentState.Update(delta)


func _physics_process(delta):
	if currentState:
		currentState.PhysicsUpdate(delta)


func on_state_transition(oldState:SimpleState, newState:SimpleState):
	#print("Transitioning from %s to %s" % [ oldState.name, newState.name ])
	currentState = newState
