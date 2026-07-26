extends Node3D

@export var camera_slicer : CameraSlicer
@export var camera:Node3D
@onready var mouse_control_canvas: MouseControl = $MouseControlCanvas
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer

func _ready() -> void:
	camera.position = self.position
	camera.basis = self.basis
	
func enable_slicer() -> void:
	mouse_control_canvas.show()
	ambience_player.play()

func disable_slicer() -> void:
	mouse_control_canvas.hide()
	ambience_player.stop()
	mouse_control_canvas.clean_up()
