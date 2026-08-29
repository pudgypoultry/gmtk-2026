extends Node
class_name DialogueCtrl

@onready var dialogue_state_manager: Dialogue_State_Manager = $DialogueStateManager

@warning_ignore("unused_signal")
signal show_slicer(index:int)
@warning_ignore("unused_signal")
signal dialogue_done()
signal begin_infinite()

func Next() -> void:
	dialogue_state_manager.next_state()

func Fail() -> void:
	dialogue_state_manager.error_state()

func _on_dialogue_state_changed(_oldState: String, newState: String) -> void:
	if newState == "Line4":
		dialogue_done.emit()
	elif newState == "DialogueDone":
		begin_infinite.emit()
