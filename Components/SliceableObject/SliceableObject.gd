extends RigidBody3D
class_name SliceableObject

@export var slice_behavior_component : SliceBehaviorComponent

var counterpart_position : Vector3


func slice():
	slice_behavior_component.execute_behavior(counterpart_position)


func finish_slice():
	slice_behavior_component.finish_slice()
