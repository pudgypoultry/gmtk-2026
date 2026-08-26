extends CanvasLayer
class_name MouseControl

@export_category("Game Rules")
@export var max_tracking_time : float = 1.25
@export var direction_debounce_samples : int = 3
@export var min_line_length : float = 150.0

@export_category("Plugging in Nodes")
@export var camera_slicer : CameraSlicer
@export var samurai: SamuraiCtrl
@export var mouse_control_state_manager: StateManager

@export_category("Debug")
@export var debug : bool = false

# used in state manager
@warning_ignore("unused_signal")
signal mouse_ready
@warning_ignore("unused_signal")
signal mouse_left
@warning_ignore("unused_signal")
signal done_slicing(how_many : int)


func clean_up() -> void:
	mouse_control_state_manager.reset_slicer()
