extends Node
class_name SliceCreator

var starting_basis : Basis


func _ready() -> void:
	var starting_vector = -get_tree().current_scene.get_viewport().get_camera_3d().basis.z


func create_slice(from : Vector2, to : Vector2):
	var plane_point_1 : Vector3 = Vector3(from.x, from.y, 0)
	var plane_point_2 : Vector3 = Vector3(to.x, to.y, 0)
	var plane_point_3 : Vector3 = Vector3(to.x, to.y, 1)
	var slice_plane = Plane(plane_point_1, plane_point_2, plane_point_3)
	var quad_mesh = create_quad_mesh_from_plane(slice_plane)
	


func create_quad_mesh_from_plane(plane: Plane, size: Vector2 = Vector2.ONE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = size
	mesh_instance.mesh = quad
	
	var origin : Vector3 = plane.normal * plane.d
	# Avoid a degenerate cross product if normal is parallel to our up hint.
	var up_hint : Vector3 = Vector3.UP
	if abs(plane.normal.dot(up_hint)) > 0.999:
		up_hint = Vector3.RIGHT
	
	# QuadMesh's face normal is +Z by default. Basis.looking_at() sets -Z
	# toward the given direction (camera convention), so we pass in the
	# negated normal to get +Z aligned with plane.normal.
	var basis := Basis.looking_at(-plane.normal, up_hint)
	mesh_instance.transform = Transform3D(basis, origin)

	return mesh_instance
