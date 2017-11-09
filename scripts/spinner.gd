extends Area2D

var init_rot = Vector2()
export var rot_int = 3
func _ready():
	init_rot = global.centre - global.vertices[0]
	global_rotation = 2*PI
	position = global.centre
	scale = Vector2(10,10)
	
func _input(event):
	if event.is_action_pressed("rotate_right"):
				
		rot_int += 1
		if rot_int > 5:
			rot_int = 0
		
		turn(PI/3)
	if event.is_action_pressed("rotate_left"):
		
		rot_int +=-1
		if rot_int < 0:
			rot_int = 5
		
		turn(-(PI/3))
	if event.is_action_pressed("collect") :
		self.collect()
		turn(0)
		
		
	if event.is_action_pressed("progress"):
		turn(0)
		

func turn(side):
	global_rotation += side
	get_tree().get_root().get_node("game").go(side)
	
func collect():
	get_tree().call_group("balls", "get_collected", rot_int)