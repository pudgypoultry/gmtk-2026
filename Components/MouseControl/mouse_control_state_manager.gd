extends StateManager

@export_category("Plugging in Nodes")
@export var mouse_ctrl:MouseControl
@export var mouse_start_position : Control
@export var slash_line : PackedScene
@export var margin_child : MarginContainer
@export var sword_image_rect : TextureRect
@export var sword_closed_image : Texture2D
@export var sword_open_image : Texture2D

@onready var preparing_state: SimpleState = $Preparing
@onready var ready_state: SimpleState = $Ready
var mouse_recording : Array = []

func _on_mouse_start_position_mouse_entered() -> void:
	if currentState == preparing_state:
		currentState.NextState()

func _on_mouse_start_position_mouse_exited() -> void:
	if currentState == ready_state:
		currentState.NextState()

func clean_up() -> void:
	currentState.ChangeState(preparing_state)
