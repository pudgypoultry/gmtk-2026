extends Node3D

@export var camera:Node3D

func _ready() -> void:
	camera.position = self.position
	camera.basis = self.basis
