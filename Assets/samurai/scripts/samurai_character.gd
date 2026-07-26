extends Node3D
class_name SamuraiCtrl

@onready var katana_target: Marker3D = $samurai/m_armature_full/Skeleton3D/KatanaTarget
@onready var katana_ik: JacobianIK3D = $samurai/m_armature_full/Skeleton3D/KatanaIK
@onready var animation_player: AnimationPlayer = $samurai/AnimationPlayer
@onready var skeleton_3d: Skeleton3D = $samurai/m_armature_full/Skeleton3D

@export var look_marker: Marker3D
enum DefaultAnim {Standing, Ready}
@export var default_animation: DefaultAnim = DefaultAnim.Ready
var record:bool = false

func _ready() -> void:
	__delayed_setup.call_deferred()
	
func set_ik_target_pos(pos:Vector3) -> void:
	katana_target.position = pos

func __delayed_setup() -> void:
	# connect to animation player signal
	animation_player.animation_changed.connect(__on_animation_changed)
	# turn off katana IK
	katana_ik.active = false
	# set animation to ready position
	if default_animation == DefaultAnim.Ready:
		animation_player.play("SamuraiAnimationLibrary/Draw_Ready_Pose")
	else:
		animation_player.play("SamuraiAnimationLibrary/Standing")
		
func slice_ready() -> void:
	animation_player.play("SamuraiAnimationLibrary/Draw_Ready_Pose")

func head_look_at(loc:Vector3) -> void:
	look_marker.position = loc
	
func draw_sword() -> void:
	animation_player.play("SamuraiAnimationLibrary/Katana_Draw_Fast_Action")
	animation_player.queue("SamuraiAnimationLibrary/Draw_Finished_Pose")
	record = true
	
func __on_animation_changed(old_anm:StringName, new_anm:StringName) -> void:
	if old_anm == "SamuraiAnimationLibrary/Katana_Draw_Fast_Action" and new_anm == "SamuraiAnimationLibrary/Draw_Finished_Pose":
		# activate katana IK
		katana_ik.active = true
	
func sheath_sword(_how_many:int=0) -> void:
	# turn off katana IK
	katana_ik.active = false
	record = false
	# play draw animation backwards
	animation_player.play_backwards("SamuraiAnimationLibrary/Katana_Draw_Fast_Action")
	if default_animation == DefaultAnim.Ready:
		animation_player.queue("SamuraiAnimationLibrary/Draw_Ready_Pose")
	else:
		animation_player.queue("SamuraiAnimationLibrary/Standing")
	
func eye_bugout() -> void:
	var left_eye_bone:int = skeleton_3d.find_bone("DEF_eye.L")
	var right_eye_bone:int = skeleton_3d.find_bone("DEF_eye.R")
	if left_eye_bone == -1 or right_eye_bone == -1:
		return # didn't find one or both bones
	skeleton_3d.set_bone_pose_scale(left_eye_bone, Vector3(5,5,5))
	skeleton_3d.set_bone_pose_scale(right_eye_bone, Vector3(5,5,5))

	
# NOTE !!! Function used for testing only - remove for final game !!!
func _unhandled_input(event: InputEvent) -> void:
	if GlobalVars.DEBUG and event is InputEventKey :
		if event.pressed:
			if event.keycode == KEY_1 and default_animation == DefaultAnim.Ready: # num 1 and player
				draw_sword()
			elif event.keycode == KEY_2 and default_animation == DefaultAnim.Ready: # num 2 and player
				sheath_sword()
			elif event.keycode == KEY_3 and default_animation == DefaultAnim.Standing: # num 3 and teacher
				eye_bugout()
