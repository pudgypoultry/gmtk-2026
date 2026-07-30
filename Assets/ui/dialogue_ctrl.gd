extends Node
class_name DialogueCtrl

@onready var dialogue_state_manager: Dialogue_State_Manager = $DialogueStateManager

func Next() -> void:
	dialogue_state_manager.next_state()

func Fail() -> void:
	dialogue_state_manager.error_state()
