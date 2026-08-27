extends State
# state for the Draw
var reaction_timer:float
var how_fast:float
var tracking_timer:float

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	reaction_timer = 0.0
	how_fast = 0.0
	tracking_timer = 0.0
	stateManager.slicer.countdown_label.show()
	stateManager.slicer.countdown_label.countend()
	stateManager.sword_image_rect.texture = stateManager.sword_open_image
	stateManager.mouse_ctrl.mouse_left.emit()
	if stateManager.slicer.samurai: 
		stateManager.slicer.samurai.draw_sword()

func __Exit(newState:SimpleState) -> void:
	# called when the state is exited
	stateManager.slicer.countdown_label.hide()
	super.__Exit(newState)
	stateManager.sword_image_rect.texture = stateManager.sword_closed_image
	if stateManager.slicer.samurai: 
		stateManager.slicer.samurai.sheath_sword()

#func FailState() -> void:
	#super.FailState()
	#stateManager.reset_slicer()

func Update(delta) -> void:
	super.Update(delta)
	reaction_timer += delta
	tracking_timer += delta
	if stateManager.mouse_moved && how_fast == 0.0:
		stateManager.how_fast = reaction_timer
	# Did not move out of circle fast enough to draw
	if reaction_timer > stateManager.slicer.reaction_time_limit or how_fast != 0.0:
		if not stateManager.mouse_moved:
			self.FailState()
			return
	var current_pos = get_viewport().get_mouse_position()
	stateManager.mouse_recording.append(current_pos)
	# Enough time has passed to allow for drawing
	if tracking_timer >= stateManager.mouse_ctrl.max_tracking_time:
		self.NextState()
