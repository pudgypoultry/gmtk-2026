extends Node3D

@onready var camera_slicer: CameraSlicer = $SubViewportContainer/SubViewport/CameraOrtho/CameraSlicer
@onready var camera_ortho: Camera3D = $SubViewportContainer/SubViewport/CameraOrtho
@export var parent3D:Node3D

func _process(_delta: float) -> void:
	camera_ortho.position = parent3D.position
	camera_ortho.basis = parent3D.basis
