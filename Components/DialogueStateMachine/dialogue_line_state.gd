extends State
class_name Dialogue_Line_State

@export_category("Game Rules")
@export var text:String
@export var allow_continue:bool
@export var deterministic_selection:int = -1
@export var slice_goal:int = 0
@export var require_slice:bool = false

var current_text:String = ""
var done_typing:bool = false
var typing_clock:float = 0.0
var current_letter:int = 0
var slice_shown:bool = false

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	current_text = ""
	typing_clock = 0.0
	current_letter = 0
	done_typing = false
	slice_shown = false
	if allow_continue:
		stateManager.continue_label.show()
	else:
		stateManager.continue_label.hide()
	stateManager.dialogue_ui_parent.slice_param_update.emit(deterministic_selection, slice_goal)

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	slice_shown = false
	super.__Exit(newState)

func Update(delta) -> void:
	super.Update(delta)
	if stateManager.is_visable() and not done_typing:
		typing_clock += delta
		# calcualte number of characters to type
		# typing_speed is the number of seconds per character
		# find number of letters we need to type
		var num_chars:int = int(typing_clock/stateManager.typing_speed) 
		# remove letters we have typed from timer
		typing_clock -= float(num_chars)*stateManager.typing_speed
		# type letters
		for i in range(current_letter, current_letter+num_chars):
			if i >= len(text):
				done_typing = true
				break
			else:
				# add letters
				current_text += text[i]
		current_letter += num_chars
		stateManager.dialogue_label.text = current_text
	# wait for typing then show slicer if it hasn't been shown
	# slicer will trigger next state
	if require_slice and not slice_shown and done_typing:
		stateManager.dialogue_ui_parent.show_slicer.emit()
		slice_shown = true
