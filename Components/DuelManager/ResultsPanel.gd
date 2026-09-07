extends Panel

@export_category("Plugging in Nodes")
@export var slice_state_manager:StateManager
@export var win_results : VBoxContainer
@export var lose_results : VBoxContainer

@onready var slice_label: Label = $WinResults/SlicesScore
@onready var reaction_time_label: Label = $WinResults/ReactionScore
@onready var win_streak_label: Label = $WinResults/WinStreakScore

func _ready() -> void:
	slice_state_manager.prep_results(self)

# Called when the node enters the scene tree for the first time.
func set_results(slices : int, reaction_time : float, win_streak : int, win : bool = true):
	if win:
		win_results.show()
		lose_results.hide()
		slice_label.text = str(slices)
		reaction_time_label.text = str(reaction_time)
		win_streak_label.text = str(win_streak)
	else:
		lose_results.show()
		win_results.hide()

func handle_next_fight_pressed():
	visible = false
	slice_state_manager.reset_slicer()
	if slice_state_manager.slicer.loop: slice_state_manager._on_duel_start()


func handle_quit_pressed():
	get_tree().change_scene_to_file("res://MainLevel/tutorial_level.tscn")


func _on_fail(fail_state : State):
	print("I have done it! The jankiest of signals!")
	lose_results.show_results(fail_state.name)
