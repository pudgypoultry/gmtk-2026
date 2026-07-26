extends Line2D
class_name SlashLine

var start
var mid
var end


func prepare(start_point : Vector2, end_point : Vector2):
	visible = false
	add_point(start_point)
	add_point(end_point)
	start = PackedVector2Array()
	start.append_array([start_point, start_point])
	mid = PackedVector2Array()
	mid.append_array([start_point, end_point])
	end = PackedVector2Array()
	end.append_array([end_point, end_point])


func _ready() -> void:
	var visual_line = Line2D.new()
	visual_line.width = width
	visual_line.width_curve = width_curve
	get_parent().add_child(visual_line)
	visual_line.points = start
	var move_tween = get_tree().create_tween().set_parallel()
	move_tween.tween_property(visual_line, "points", mid, 0.1)
	await get_tree().create_timer(0.21).timeout
	move_tween.is_queued_for_deletion()
	move_tween = get_tree().create_tween().set_parallel()
	move_tween.tween_property(visual_line, "points", end, 0.1)
	await get_tree().create_timer(0.21).timeout
	visual_line.queue_free()
