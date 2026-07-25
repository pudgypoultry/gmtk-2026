extends Node3D

@onready var camera_slicer: CameraSlicer = $SubViewportContainer/SubViewport/CameraOrtho/CameraSlicer
@onready var camera_ortho: Camera3D = $SubViewportContainer/SubViewport/CameraOrtho
@export var parent3D:Node3D
@onready var menu_container: Node3D = $menu_container
const MAINMENU_CONTAINER := preload("res://Assets/menu/mainmenu_container.tscn")

func _process(_delta: float) -> void:
	camera_ortho.position = parent3D.position
	camera_ortho.basis = parent3D.basis

func disable_menu() -> void:
	menu_container.queue_free()

func enable_menu() -> void:
	var main_menu := MAINMENU_CONTAINER.instantiate()
	self.add_child(main_menu)

func enable_settings() -> void:
	pass
	
func enable_credits() -> void:
	pass
