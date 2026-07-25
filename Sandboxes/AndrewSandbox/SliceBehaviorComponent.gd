extends Node
class_name SliceBehaviorComponent

@onready var actor_reference : Node3D = get_parent()

@export var movement_speed : float = 5.0
@export var movement_speed_decay : float = 0.97

var velocity : Vector3 = Vector3.ZERO
var started_movement : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started_movement:
		actor_reference.position += velocity * movement_speed * delta
		movement_speed = movement_speed * movement_speed_decay


func execute_behavior(counterpart_position : Vector3):
	started_movement = true
	var direction_to_move = actor_reference.global_position - counterpart_position
	print(str(actor_reference.global_position) + "	:	" + str(counterpart_position))
	velocity = direction_to_move.normalized()
	await get_tree().create_timer(3.0).timeout
	actor_reference.queue_free()
