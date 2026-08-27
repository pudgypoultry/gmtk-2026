extends State

# needs to just wait for a signal and then transition to SliceReady
func _on_go_next():
	NextState()
