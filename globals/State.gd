# Adapted from https://github.com/pudgypoultry/godotwildjam7-25/blob/main/Sandboxes/Stella/State.gd
extends SimpleState
# skeleton of this code comes from this tutorial:
# https://www.youtube.com/watch?v=ow_Lum-Agbs&ab_channel=Bitlytic
class_name State

@export_category("Plugging in Nodes")
@export var error_state:State

func FailState() -> void:
	self.ChangeState(error_state)
