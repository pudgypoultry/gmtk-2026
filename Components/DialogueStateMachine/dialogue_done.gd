extends Dialogue_Line_State


func __Enter(oldState:SimpleState) -> void:
	super.__Enter(oldState)
	# disable dialogue
	stateManager.dialogue_ui_parent.hide()
