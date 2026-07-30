extends Node

class_name StateManager

@export var initialState : State
var currentState : State

func _ready():
	# states are child nodes of the State Manager node
	for child in get_children():
		if child is State:
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


func on_state_transition(oldState:State, newState:State):
	#print("Transitioning from %s to %s" % [ oldState.name, newState.name ])
	currentState = newState
