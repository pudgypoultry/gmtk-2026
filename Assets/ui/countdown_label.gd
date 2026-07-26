extends Control
@onready var label: Label = $Panel/Label

func countdown() -> void:
	label.text = "Three"
	await get_tree().create_timer(.9).timeout
	label.text = "Two"
	await get_tree().create_timer(.9).timeout
	label.text = "One"
	await get_tree().create_timer(.9).timeout
	label.text = ".  .  .  .  .  ."
	
func countend() -> void:
	label.text = "Draw!"
	await get_tree().create_timer(1).timeout
	label.text = ""
