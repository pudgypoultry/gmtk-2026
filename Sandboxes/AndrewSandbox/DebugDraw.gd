extends MarginContainer
class_name LineFolder

func _draw():
	if get_parent().debug:
		for i in range(len(get_parent().mouse_recording) - 1):
			# print("drawing line: " + str(i))
			draw_line(get_parent().mouse_recording[i+1], get_parent().mouse_recording[i], Color.GREEN, -1.0)
		for i in range(len(get_parent().mouse_recording)):
			draw_circle(get_parent().mouse_recording[i], 3, Color.GREEN)


func clean_up():
	var children = get_children()
	for i in range(len(children)):
		var current = children.pop_front()
		if current is Line2D:
			current.queue_free()
