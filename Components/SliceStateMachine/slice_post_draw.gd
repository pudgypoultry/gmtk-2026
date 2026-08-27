extends State
# state for adding an observation delay between slicing and results
var post_draw_delay_timer:float

func __Enter(oldState:SimpleState) -> void:
	# called when the state is entered
	super.__Enter(oldState)
	post_draw_delay_timer = 0.0

func Update(delta) -> void:
	super.Update(delta)
	post_draw_delay_timer += delta
	if post_draw_delay_timer >= stateManager.slicer.post_draw_time_limit:
		self.NextState()
