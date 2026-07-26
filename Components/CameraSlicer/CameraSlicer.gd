extends Node3D
class_name CameraSlicer

@export_category("Game Rules")
@export var depth : float = 5

@export_category("Plugging in Nodes")
@export var slicer : Node3D
@export var slicer_area : Area3D
@export var rigidbody_parent : Node3D
@export var audio_player : AudioStreamPlayer3D
@export var camera: Camera3D
@export var camera_vis_layer: int = 2
signal sliced_obj(name:String)


var cross_section_material = preload("res://addons/concave mesh slicer/Example/cross_section_material.tres")
var slicer_original_position
var slicer_original_rotation
var sliced_object_array = []

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
	if len(mesh.get_faces()) > 2:
		var v1 = mesh.get_faces()[0]
		var v2 = mesh.get_faces()[1]
		var v3 = mesh.get_faces()[2]
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
		for i in range(0, 6, 3):
			var v1 = vertices[i]
			var v2 = vertices[i + 1]
			var v3 = vertices[i + 2]
			volume += abs(v1.dot(v2.cross(v3))) / 6.0
	return volume


func perform_slice(start_point: Vector2, end_point: Vector2):
	update_slicer_rotation(start_point, end_point)
	audio_player.play()
	await get_tree().create_timer(0.1).timeout
	for body in slicer_area.get_overlapping_bodies().duplicate():
		if body is RigidBody3D:
			print("	Currently slicing: ", body)
			sliced_obj.emit(body.name)
			#The convert the slicer's transform to be relative/local to the meshinstance.
			#Get all meshinstance3d nodes, for loop over each of them
			var meshinstance:MeshInstance3D 
			for child in body.get_children():
				if child is MeshInstance3D:
					meshinstance = child
					break
			if not meshinstance:
				return
			#var meshinstance:MeshInstance3D = body.get_node("SliceableMesh")
			var slice_transform = meshinstance.global_transform.affine_inverse() * slicer.global_transform
			body.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
			#Slice the mesh
			var meshes := MeshSlicer.slice_mesh(slice_transform,meshinstance.mesh,cross_section_material)
			meshinstance.mesh = meshes[0]
			var body2 = body.duplicate()
			rigidbody_parent.add_child(body2)
			
			var meshinstance2 : MeshInstance3D
			for child in body2.get_children():
				if child is MeshInstance3D:
					meshinstance2 = child
					break
			if not meshinstance2:
				return
			meshinstance2.mesh = meshes[1]
			
			#get mesh size
			var aabb = meshes[0].get_aabb()
			var aabb2 = meshes[1].get_aabb()
			#meshinstance.set_layer_mask_value(camera_vis_layer, true)
			#meshinstance2.set_layer_mask_value(camera_vis_layer, true)
			
			body.center_of_mass = meshinstance.to_global(calculate_center_of_mass(meshes[0]))
			body2.center_of_mass = meshinstance.to_global(calculate_center_of_mass(meshes[1]))
			
			body.counterpart_position = body2.center_of_mass
			body2.counterpart_position = body.center_of_mass
			
			body.slice()
			body2.slice()
			
			if body not in sliced_object_array:
				sliced_object_array.append(body)
			if body2 not in sliced_object_array:
				sliced_object_array.append(body2)
			
			#queue_free() if the mesh is too small
			if aabb2.size.length() < 0.05:
				body2.queue_free()
			if aabb.size.length() < 0.05:
				body.queue_free()
