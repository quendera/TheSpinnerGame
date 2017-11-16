extends Area2D

export var rot_int = 3
var move_time = .05

func _ready():
	#init_rot = global.centre - global.vertices[0]
	global_rotation = 2*PI
	position = global.centre
	scale = Vector2(10,10)
	#set_fixed_process(true)
	
func _process(delta):
	var moveDir = fposmod(global_rotation/PI*3 - float(rot_int) - 3 ,6)
	if moveDir > 3:
		moveDir = moveDir-6
	moveDir = moveDir*delta/move_time
	global_rotation -= moveDir
	
func _input(event):
	var angVel = 0
	var advance = 0
	if event.is_action_pressed("rotate_right"):
		angVel = 1
		advance = 1
	if event.is_action_pressed("rotate_left"):
		angVel = -1
		advance = 1
	if event.is_action_pressed("collect") :
		self.collect()
	if event.is_action_pressed("progress"):
		advance = 1
		global.start_step = 1
	rot_int = fposmod(rot_int+angVel,6)
	turn(advance*global.start_step)

func turn(advance):
	#global_rotation += side*PI/3
	get_tree().get_root().get_node("game").go(advance)
	
func collect():
	get_tree().call_group("balls", "get_collected", rot_int)