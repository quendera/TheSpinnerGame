extends Area2D

var rot_int = 3
var data_line = {"ke_time":0, "ke_pos":0,  "ke_ID":0, "ke_startstep":0} #"ke_pos_vis":0,
var keyID

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
	moveDir = moveDir*delta/global.move_time
	global_rotation -= moveDir
	
func _input(event):
	var angVel = 0
	var advance = 0
	keyID = -1
	if event.is_action_pressed("rotate_right"):
		keyID = 0
		angVel = 1
		advance = 1
	if event.is_action_pressed("rotate_left"):
		keyID = 1
		angVel = -1
		advance = 1
	if event.is_action_pressed("collect") :
		keyID = 2
		self.collect()
		global.start_step = 1
	if event.is_action_pressed("progress"):
		keyID = 3
		advance = 1
		global.start_step = 1
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_node("game").save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	if keyID >= 0:
		log_data()
	rot_int = fposmod(rot_int+angVel,6)
	turn(advance*global.start_step)

func log_data():
	data_line["ke_time"] = global.dt
	data_line["ke_pos"] = rot_int
	#data_line["ke_pos_vis"] = global_rotation/PI*3
	data_line["ke_ID"] = keyID
	data_line["ke_startstep"] = global.start_step
	for key in data_line.keys():
		global.data[key].push_back(data_line[key])

#func turn(advance):
#	if advance:
#		get_tree().call_group("balls", "step")
#	var get_len = get_tree().get_nodes_in_group("balls").size()
#	if  get_len == 0:
#		$Spawner.mySpawn()

func turn(advance):
	#global_rotation += side*PI/3
	get_tree().get_root().get_node("game").go(advance)
	
func collect():
	get_tree().call_group("balls", "get_collected", rot_int)