# Adapted from https://github.com/pudgypoultry/godotwildjam7-25/blob/main/Sandboxes/Stella/State.gd
extends SimpleState
# skeleton of this code comes from this tutorial:
# https://www.youtube.com/watch?v=ow_Lum-Agbs&ab_channel=Bitlytic
class_name State

@export_category("Plugging in Nodes")
@export var error_state:State
@export var is_slicer_ui_state:bool = true
signal set_slicer_ui(visable:bool)

func FailState() -> void:
	print("FailState active")
	stateManager.win_streak = 0
	stateManager.current_score = 0
	self.ChangeState(error_state)

func __Enter(oldState:SimpleState) -> void:
	super.__Enter(oldState)
	set_slicer_ui.emit(is_slicer_ui_state)
