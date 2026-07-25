extends Marker3D

@export var camera:Node3D

func _process(_delta: float) -> void:
	camera.position = self.position
	camera.basis = self.basis
