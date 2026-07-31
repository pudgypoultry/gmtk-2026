extends Control
class_name Countdown_Label

@onready var label: Label = $Panel/Label
@onready var countdown_sound: AudioStreamPlayer3D = $Countdown
@onready var draw_sound: AudioStreamPlayer3D = $DrawSound

func countdown() -> void:
	countdown_sound.play()
	label.text = "Three"
	await get_tree().create_timer(.9).timeout
	label.text = "Two"
	await get_tree().create_timer(.9).timeout
	label.text = "One"

func wait() -> void:
	label.text = ".  .  .  .  .  ."

func countend() -> void:
	draw_sound.play()
	label.text = "Draw!"

func stop() -> void:
	countdown_sound.stop()
	draw_sound.stop()
