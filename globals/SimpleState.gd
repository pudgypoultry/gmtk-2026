# Adapted from https://github.com/pudgypoultry/godotwildjam7-25/blob/main/Sandboxes/Stella/State.gd
extends Node
# skeleton of this code comes from this tutorial:
# https://www.youtube.com/watch?v=ow_Lum-Agbs&ab_channel=Bitlytic
class_name SimpleState

@export_category("Plugging in Nodes")
@export var next_state:SimpleState

var stateManager : StateManager
signal Transitioned(oldState:SimpleState, newState:SimpleState)

func NextState() -> void:
	self.ChangeState(next_state)

# use this function to transition between states
func ChangeState(newState:SimpleState) -> void:
	self.__Exit(newState)

@warning_ignore("unused_parameter")
func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	pass

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	Transitioned.emit(self, newState)
	newState.__Enter(self)

@warning_ignore("unused_parameter")
func Update(delta) -> void:
	pass

@warning_ignore("unused_parameter")
func PhysicsUpdate(delta) -> void:
	pass
