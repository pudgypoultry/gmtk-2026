extends Panel

@export_category("Plugging in Nodes")
@export var slice_state_manager:StateManager

@onready var slice_label: Label = $WinResults/SlicesScore
@onready var reaction_time_label: Label = $WinResults/ReactionScore
@onready var win_streak_label: Label = $WinResults/WinStreakScore

# Called when the node enters the scene tree for the first time.
func set_results(slices : int, reaction_time : float, win_streak : int):
	slice_label.text = str(slices)
	reaction_time_label.text = str(reaction_time)
	win_streak_label.text = str(win_streak)


func handle_next_fight_pressed():
	visible = false
	slice_state_manager.reset_slicer()
	slice_state_manager.start_slicer()


func handle_quit_pressed():
	get_tree().change_scene_to_file("res://MainLevel/tutorial_level.tscn")
