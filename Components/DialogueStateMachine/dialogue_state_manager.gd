extends StateManager
class_name Dialogue_State_Manager

@export_category("Game Rules")
@export var typing_speed: float = 0.03

@export_category("Plugging in Nodes")
@export var global_error_state:Dialogue_Line_State
@export var dialogue_label:Label
@export var continue_label:Label
@export var dialogue_ui_parent:DialogueCtrl

var original_continue_text : String = ""

signal dialogueStateChanged(oldState:String, newState:String)

func _ready():
	super._ready()
	original_continue_text = continue_label.text
	# set all error states to the global error state if one is set
	if global_error_state:
		for child in get_children():
			if child is Dialogue_Line_State:
				if child.error_state:
					pass # don't set the error state if it already has one
				else:
					child.error_state = global_error_state

func is_visable() -> bool:
	return dialogue_label.is_visible_in_tree()

func next_state() -> void:
	currentState.NextState()

func error_state(text:String) -> void:
	global_error_state.text = text
	currentState.FailState()

func _unhandled_input(event):
	if is_visable() and event.is_action_pressed("ui_accept") and currentState.allow_continue:
		currentState.NextState()
		get_viewport().set_input_as_handled()

func on_state_transition(oldState:SimpleState, newState:SimpleState):
	dialogueStateChanged.emit(oldState.name, newState.name)
	currentState = newState


func change_continue_text(new_text : String):
	continue_label.text = new_text

func reset_continue_text():
	continue_label.text = original_continue_text
