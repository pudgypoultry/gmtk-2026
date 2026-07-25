extends Node3D
@onready var dialogue= $UI/Dialogue
@onready var speaker=  $UI/Dialogue/Content/TextContainer/Speaker
@onready var dialogue_text = $UI/Dialogue/Content/TextContainer/DialogueText
@onready var continue_label= $UI/Dialogue/Content/TextContainer/Continue
var dialogue_lines = [
		"Ah good i was beginning to think 
		you werent going to show up.",
		" Lets begin before this headache kills me. 
		Let your hand be the blade (MOVE YOUR MOUSE TO SLICE)",
		" GOOD good! Now do you think your skills can cut 
		down this bamboo instead of just AIR HAHA",
		" Well... 
		YOU STILL HAVE MUCH TO LEARN"]
var current_line=0

@onready var samurai: SamuraiCtrl = $Samurai
@onready var samurai_master: SamuraiCtrl = $Samurai_Master
@onready var camera_loc_active_game: Marker3D = $CameraLoc_ActiveGame
@onready var camera_loc_menu: Marker3D = $CameraLoc_Menu
@onready var camera_perspective: Camera3D = $"Camera-Perspective"

@onready var main_menu_3d: Node3D = $"Camera-Perspective/MainMenu3D"
@export var playbutton_slice_name:String = "Playoption"


func _ready() -> void:
	__delayed_setup.call_deferred()
	
func __delayed_setup() -> void:
	var loc:Vector3 = samurai.position
	samurai_master.head_look_at(loc)
	camera_perspective.position = camera_loc_menu.position
	main_menu_3d.camera_slicer.sliced_obj.connect(on_sliced_obj)
	
func on_sliced_obj(name:String) -> void:
	if name == playbutton_slice_name:
		move_camera(false)

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
	
func show_dialogue():
	current_line=0
	dialogue.show()
	speaker.text="Master:"
	dialogue_text.text= dialogue_lines[current_line]
	continue_label.text="Press [Space]"
	
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		next_dialogue()
	
func next_dialogue():
	current_line +=1
	if current_line>= dialogue_lines.size():
		dialogue.hide()
		return
	dialogue_text.text = dialogue_lines[current_line]
	
	
	
