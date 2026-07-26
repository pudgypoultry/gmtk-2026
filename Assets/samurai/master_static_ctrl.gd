extends Node3D

@onready var master_static: Node3D = $master_static
@onready var master_top_half: Node3D = $master_top_half
@onready var master_bottom_half: Node3D = $master_bottom_half

func _ready() -> void:
	master_static.show()
	master_bottom_half.hide()
	master_top_half.hide()

func play_animation() -> void:
	await get_tree().create_timer(0.2).timeout
	master_static.hide()
	master_bottom_half.show()
	master_top_half.show()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(master_top_half, "rotation", Vector3(0,0, (80.0 * PI) / 180.0), 0.5)
