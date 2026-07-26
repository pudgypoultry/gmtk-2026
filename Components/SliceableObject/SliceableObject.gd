extends RigidBody3D
class_name SliceableObject

@export var slice_behavior_component : SliceBehaviorComponent
@export var healthy_mesh : Node3D
@export var sliced_mesh : MeshInstance3D

var counterpart_position : Vector3
var is_sliced = false


func _ready() -> void:
	if healthy_mesh and sliced_mesh:
		healthy_mesh.visible = true
		sliced_mesh.visible = false
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)


func slice():
	if healthy_mesh and sliced_mesh:
		healthy_mesh.visible = false
		sliced_mesh.visible = true
	is_sliced = true
	slice_behavior_component.execute_behavior(counterpart_position)


func finish_slice():
	slice_behavior_component.finish_slice()
