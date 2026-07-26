extends Node3D

@export var camera:Node3D
@onready var mouse_control_canvas: MouseControl = $MouseControlCanvas

func _ready() -> void:
	camera.position = self.position
	camera.basis = self.basis
	
#func enable_slicer() -> void:
	#mouse_control_canvas.show()
