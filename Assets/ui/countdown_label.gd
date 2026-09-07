extends Control
class_name Countdown_Label

@onready var label: Label = $Panel/Label
@onready var countdown_sound: AudioStreamPlayer3D = $Countdown
@onready var draw_sound: AudioStreamPlayer3D = $DrawSound
var is_countdown:bool = false
var t:float = 0
var i:int = 0
var values:Array[String] = ["Three", "Two", "One"]

func countdown() -> void:
	is_countdown = true
	countdown_sound.play()
	t = 0
	i = 0
	label.text = values[i]
	i += 1

func wait() -> void:
	label.text = ".  .  .  .  .  ."

func countend() -> void:
	draw_sound.play()
	label.text = "Draw!"

func stop() -> void:
	is_countdown = false
	countdown_sound.stop()
	draw_sound.stop()
	t = 0

func _process(delta: float) -> void:
	t += delta
	if is_countdown and t > 0.9:
		label.text = values[i]
		i += 1
		is_countdown = i < 3
		t = 0
