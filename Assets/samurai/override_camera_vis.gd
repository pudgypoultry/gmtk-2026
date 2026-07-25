extends Node3D

@export var visibility_layer:int = 1

func _ready() -> void:
	for child in self.get_children():
		if child is VisualInstance3D:
			child.set_layer_mask_value(visibility_layer, true)
