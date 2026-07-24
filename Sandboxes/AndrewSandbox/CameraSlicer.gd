extends Node3D
class_name CameraSlicer

@export_category("Game Rules")
@export var depth : float = .5

@export_category("Plugging in Nodes")
@export var slicer : Node3D
@export var slicer_area : Area3D
@export var rigidbody_parent : Node3D


@onready var camera : Camera3D = get_parent()


var cross_section_material = preload("res://addons/concave mesh slicer/Example/cross_section_material.tres")
var slicer_original_position
var slicer_original_rotation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	slicer_original_position = slicer.position
	slicer_original_rotation = slicer.rotation


func update_slicer_rotation(start_point: Vector2, end_point: Vector2) -> void:
	slicer.position = slicer_original_position
	slicer.rotation = slicer_original_rotation
	var start_local := camera.to_local(camera.project_position(start_point, depth))
	var end_local := camera.to_local(camera.project_position(end_point, depth))
	
	global_position = camera.to_global((start_local + end_local) * 0.5)
	
	var diff := end_local - start_local
	global_rotation = camera.global_rotation
	rotate_object_local(Vector3.FORWARD, -atan2(-diff.x, diff.y))


func calculate_center_of_mass(mesh:ArrayMesh):
	#Not sure how well this work
	var meshVolume = 0
	var temp = Vector3(0,0,0)
	for i in range(len(mesh.get_faces())/3):
		var v1 = mesh.get_faces()[i]
		var v2 = mesh.get_faces()[i+1]
		var v3 = mesh.get_faces()[i+2]
		var center = (v1 + v2 + v3) / 3
		var volume = (Geometry3D.get_closest_point_to_segment_uncapped(v3,v1,v2).distance_to(v3)*v1.distance_to(v2))/2
		meshVolume += volume
		temp += center * volume
	
	if meshVolume == 0:
		return Vector3.ZERO
	return temp / meshVolume


func calculate_mesh_volume(mesh: ArrayMesh) -> float:
	var volume = 0.0
	for surface in range(mesh.get_surface_count()):
		var arrays = mesh.surface_get_arrays(surface)
		var vertices = arrays[Mesh.ARRAY_VERTEX]
		for i in range(0, vertices.size(), 3):
			var v1 = vertices[i]
			var v2 = vertices[i + 1]
			var v3 = vertices[i + 2]
			volume += abs(v1.dot(v2.cross(v3))) / 6.0
	return volume


func perform_slice(start_point: Vector2, end_point: Vector2):
	update_slicer_rotation(start_point, end_point)
	await get_tree().create_timer(0.1).timeout
	print("Trying to slice")
	print(slicer.position)
	print(position)
	print(slicer_area.get_overlapping_bodies())
	for body in slicer_area.get_overlapping_bodies().duplicate():
		if body is StaticBody3D:
			print("	Currently slicing: ", body)
			#The convert the slicer's transform to be relative/local to the meshinstance.
			var meshinstance:MeshInstance3D = body.get_node("SliceableMesh")
			var slice_transform = meshinstance.global_transform.affine_inverse() * slicer.global_transform
			
			#Slice the mesh
			var meshes := MeshSlicer.slice_mesh(slice_transform,meshinstance.mesh,cross_section_material)
			meshinstance.mesh = meshes[0]
			meshinstance.position.x += randf()
			var body2 = body.duplicate()
			rigidbody_parent.add_child(body2)
			meshinstance = body2.get_node("SliceableMesh")
			meshinstance.mesh = meshes[1]
			meshinstance.position.x -= randf()
			
			#get mesh size
			var aabb = meshes[0].get_aabb()
			var aabb2 = meshes[1].get_aabb()
			
			#queue_free() if the mesh is too small
			if aabb2.size.length() < 0.3:
				body2.queue_free()
			if aabb.size.length() < 0.3:
				body.queue_free()
