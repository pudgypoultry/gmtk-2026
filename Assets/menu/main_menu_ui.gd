extends Panel

@onready var main_menu_pannel: Panel = $MainMenuPannel
@onready var settings_pannel: Panel = $SettingsPannel
@onready var credits_pannel: Panel = $CreditsPannel
@onready var slice_player: AudioStreamPlayer = $SettingsPannel/VBoxContainer/SlicePlayer

@export var menu_change_delay:float = 1
signal menu_changed(state:GlobalVars.MenuChange)

func _ready() -> void:
	main_menu_pannel.show()
	settings_pannel.hide()
	credits_pannel.hide()

func _on_play_pressed() -> void:
	main_menu_pannel.hide()
	menu_changed.emit(GlobalVars.MenuChange.Play)

func _on_settings_pressed() -> void:
	main_menu_pannel.hide()
	menu_changed.emit(GlobalVars.MenuChange.Settings)
	await get_tree().create_timer(menu_change_delay).timeout
	settings_pannel.show()

func _on_credits_pressed() -> void:
	main_menu_pannel.hide()
	menu_changed.emit(GlobalVars.MenuChange.Credits)
	await get_tree().create_timer(menu_change_delay).timeout
	credits_pannel.show()

func _on_quit_pressed() -> void:
	main_menu_pannel.hide()
	menu_changed.emit(GlobalVars.MenuChange.Quit)

func _on_return_pressed() -> void:
	settings_pannel.hide()
	credits_pannel.hide()
	menu_changed.emit(GlobalVars.MenuChange.Menu)
	await get_tree().create_timer(menu_change_delay).timeout
	main_menu_pannel.show()


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		slice_player.play()
