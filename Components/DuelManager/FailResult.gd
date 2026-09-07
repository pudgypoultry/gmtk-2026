extends VBoxContainer

@export var fail_be_patient : Label
@export var fail_countdown : Label
@export var fail_draw : Label
@export var fail_results : Label

var label_dict = {}
var all_labels : Array = []

func _ready() -> void:
	all_labels = [fail_be_patient, fail_countdown, fail_draw, fail_results]
	label_dict = {"SliceCountdown" : fail_be_patient, "SliceWaiting" : fail_countdown, "SliceDraw" : fail_draw, "SliceResults" : fail_results}

func reset_results() -> void:
	for label in all_labels:
		label.hide()

func show_results(state_name : String) -> void:
	reset_results()
	label_dict[state_name].show()
