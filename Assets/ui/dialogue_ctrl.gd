extends Node
class_name DialogueCtrl

@export var typing_speed: float = 0.03
@onready var dialogue= $UI/Dialogue
@onready var speaker=  $UI/Dialogue/Content/TextContainer/Speaker
@onready var dialogue_text = $UI/Dialogue/Content/TextContainer/DialogueText
@onready var continue_label= $UI/Dialogue/Content/TextContainer/Continue
var dialogue_lines: Array[String]=[ 
		"Ah good i was beginning to think 
		you werent going to show up.",
		"Begin before this headache kills me. 
		Let your hand be the blade 
		MOVE YOUR MOUSE TO SLICE",
		" GOOD good! Now do you think your skills can cut 
		down this bamboo instead of just AIR HAHA",
		" Well, 
		YOU STILL HAVE MUCH TO LEARN"]
var current_line=0
var dialogue_active: bool = false
var is_typing: bool = false
var typing_id: int=0

func show_dialogue() -> void:
	dialogue_active= true
	current_line=0
	dialogue.show()
	speaker.text="Master:"
	
	continue_label.text="Press [Space] to continue"
	type_text(dialogue_lines[current_line])
	
	
func _unhandled_input(event):
	if dialogue_active and event.is_action_pressed("ui_accept"):
		next_dialogue()
		get_viewport().set_input_as_handled()
	
func next_dialogue():
	if is_typing:
		finish_current_line()
		return
	current_line +=1
	if current_line>= dialogue_lines.size():
		end_dialogue()
		return
	type_text(dialogue_lines[current_line])
	
func type_text(text_to_show: String) -> void:
		typing_id +=1
		var current_typing_id := typing_id
		is_typing=true
		dialogue_text.text=""
		
		for letter in text_to_show:
			if current_typing_id != typing_id:
				return
			dialogue_text.text += letter
			await get_tree().create_timer(typing_speed).timeout
		if current_typing_id == typing_id:
			is_typing = false
			
func finish_current_line() -> void:
	typing_id +=1
	is_typing= false
	
	dialogue_text.text= dialogue_lines[current_line]
	
func end_dialogue() -> void:
	typing_id =+1
	is_typing=false
	dialogue_active= false
	dialogue.hide()
