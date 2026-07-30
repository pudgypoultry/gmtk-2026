extends State
class_name Dialogue_Line_State

@export_category("Game Rules")
@export var text:String
@export var allow_continue:bool

@export_category("Plugging in Nodes")
@export var next_state:Dialogue_Line_State
@export var error_state:Dialogue_Line_State

var current_text:String = ""
var done_typing:bool = false
var typing_clock:float = 0.0
var current_letter:int = 0

func NextState() -> void:
	self.ChangeState(next_state)

func FailState() -> void:
	self.ChangeState(error_state)

func __Enter(oldState:State) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	current_text = ""
	typing_clock = 0.0
	current_letter = 0
	done_typing = false

func __Exit(newState:State) -> void:
	# called when the state is exited
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
	

func PhysicsUpdate(delta) -> void:
	super.PhysicsUpdate(delta)
