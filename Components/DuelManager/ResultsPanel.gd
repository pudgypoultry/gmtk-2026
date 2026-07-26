extends Panel

@export var duel_manager : DuelManager
@export var slice_label : Label
@export var reaction_time_label : Label
@export var win_streak_label : Label

# Called when the node enters the scene tree for the first time.
func set_results(slices : int, reaction_time : float, win_streak : int):
	visible = true
	slice_label.text = str(slices)
	reaction_time_label.text = str(reaction_time)
	win_streak_label.text = str(win_streak)


func handle_next_fight_pressed():
	visible = false
	duel_manager.reset_duel()


func handle_quit_pressed():
	get_tree().change_scene_to_file("res://MainLevel/tutorial_level.tscn")
