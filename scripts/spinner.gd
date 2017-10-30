extends Area2D
# class member variables go here, for example:
func _input(event):
	if event.is_action_pressed("rotate_right"):
		turn(20)
		
	if event.is_action_pressed("rotate_left"):
		turn(-20)
		
	if event.is_action_pressed("collect") or event.is_action_pressed("progress"):
		turn(0)
		
	if event.is_action_pressed("spawn"):
		turn(0)
		
func turn(side):
	get_tree().get_root().get_node("game").go(side)