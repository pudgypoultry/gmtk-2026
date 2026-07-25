extends Node3D
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


@onready var samurai: SamuraiCtrl = $Samurai
@onready var samurai_master: SamuraiCtrl = $Samurai_Master
@onready var camera_loc_active_game: Marker3D = $CameraLoc_ActiveGame
@onready var camera_loc_menu: Marker3D = $CameraLoc_Menu
@onready var camera_perspective: Camera3D = $"Camera-Perspective"

@onready var main_menu_3d: Node3D = $"Camera-Perspective/MainMenu3D"
@export var play_button_slice_name:String = "play_option"
@export var settings_button_slice_name:String = "settings_option"
@export var credits_button_slice_name:String = "credits_option"
@export var quit_button_slice_name:String = "quit_option"

@export var typing_speed: float = 0.03


func _ready() -> void:
	__delayed_setup.call_deferred()
	
func __delayed_setup() -> void:
	var loc:Vector3 = samurai.position
	samurai_master.head_look_at(loc)
	camera_perspective.position = camera_loc_menu.position
	main_menu_3d.camera_slicer.sliced_obj.connect(on_sliced_obj)
	
func on_sliced_obj(name:String) -> void:
	if name == play_button_slice_name:
		move_camera(false)
	elif name == quit_button_slice_name:
		await get_tree().create_timer(0.5).timeout
		get_tree().quit()
	elif name == settings_button_slice_name:
		pass
	elif name == credits_button_slice_name:
		pass

func move_camera(menu_active:bool) -> void:
	var loc:Vector3 = Vector3.ZERO
	if menu_active:
		loc = camera_loc_menu.position
	else:
		loc = camera_loc_active_game.position
	var tween = get_tree().create_tween()
	tween.tween_property(camera_perspective, "position", loc, 1.0)
	tween.finished.connect(show_dialogue)
	#tween.tween_callback(### advance game function goes hear)
	
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
				
					

	
	
	
