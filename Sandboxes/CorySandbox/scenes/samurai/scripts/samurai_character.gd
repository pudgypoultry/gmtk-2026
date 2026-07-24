extends Node3D

@onready var katana_target: Marker3D = $samurai/m_armature_full_002/Skeleton3D/KatanaTarget
@onready var katana_ik: JacobianIK3D = $samurai/m_armature_full_002/Skeleton3D/KatanaIK
@onready var animation_player: AnimationPlayer = $samurai/AnimationPlayer

func _ready() -> void:
	__delayed_setup.call_deferred()
	
func __delayed_setup() -> void:
	# connect to animation player signal
	animation_player.animation_changed.connect(__on_animation_changed)
	# turn off katana IK
	katana_ik.influence = 0.0
	# set animation to ready position
	animation_player.play("Draw_Ready_Pose")
	
func draw_sword() -> void:
	animation_player.play("Katana_Draw_Fast_Action")
	animation_player.queue("Draw_Finished_Pose")
	
func __on_animation_changed(old_anm:StringName, new_anm:StringName) -> void:
	if old_anm == "Katana_Draw_Fast_Action" and new_anm == "Draw_Finished_Pose":
		# activate katana IK
		katana_ik.influence = 1.0
	
func sheath_sword() -> void:
	# turn off katana IK
	katana_ik.influence = 0.0
	# play draw animation backwards
	animation_player.play_backwards("Katana_Draw_Fast_Action")
	animation_player.queue("Draw_Ready_Pose")
	
# NOTE !!! Function used for testing only - remove for final game !!!
func _unhandled_input(event: InputEvent) -> void:
	if GlobalVars.DEBUG and event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				draw_sword()
			elif event.keycode == KEY_2:
				sheath_sword()
