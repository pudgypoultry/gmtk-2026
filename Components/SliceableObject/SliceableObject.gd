extends RigidBody3D
class_name SliceableObject

@export var slice_behavior_component : SliceBehaviorComponent
@export var healthy_mesh : MeshInstance3D
@export var sliced_mesh : MeshInstance3D

var counterpart_position : Vector3
var is_sliced = false


func _ready() -> void:
	healthy_mesh.set_layer_mask_value(1, true)
	sliced_mesh.set_layer_mask_value(1, false)
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)


func slice():
	healthy_mesh.set_layer_mask_value(1, false)
	sliced_mesh.set_layer_mask_value(1, true)
	is_sliced = true
	slice_behavior_component.execute_behavior(counterpart_position)


func finish_slice():
	slice_behavior_component.finish_slice()
