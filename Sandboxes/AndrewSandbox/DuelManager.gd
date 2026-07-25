extends Node

@export_category("Game Rules")
@export var delay_start_base : float = 0.75
@export var countdown_timer : float = 3.0

@export_category("Plugging in Nodes")
@export var enemy_folder : Node3D
@export var camera_slicer : CameraSlicer
@export var mouse_control : MouseControl
@export var countdown_sound : AudioStreamPlayer3D
@export var draw_sound : AudioStreamPlayer3D
@export var grade_sound : AudioStreamPlayer3D
@export var draw_text : Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_text.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Pass this function a dictionary of enemy packedscene keys and Vector3 positions
func prepare_duel(enemies : Dictionary):
	for enemy : PackedScene in enemies.keys():
		var next_enemy = enemy.instantiate()
		enemy_folder.add_child(next_enemy)
		next_enemy.position = enemies[enemy]


func begin_countdown():
	countdown_sound.play()
	await get_tree().create_timer(countdown_timer).timeout
	var random_count_add = randf_range(0.25, 4.5)
	await get_tree().create_timer(random_count_add)
	draw_text.visible = true
	draw_sound.play()


func end_duel():
	pass
