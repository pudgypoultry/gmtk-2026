extends Node3D

@export var copy_target:Node3D

func _ready() -> void:
	self.transform = copy_target.transform
	self.basis = copy_target.basis
