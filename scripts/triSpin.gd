extends Node2D

var rot_int = 3
var angVel = 0
var turn_start = 0
var data_line = {"ke_time":0, "ke_pos":0,  "ke_ID":0, "ke_startstep":0} #"ke_pos_vis":0,
var keyID
var order = [[0,1],[6,1],[6,-1],[0,-1]]

func _ready():
	global_rotation = 0
	position = global.centre
	set_z(1)
	
func _draw():
	var coords = PoolVector2Array()
	coords.resize(4)
	for i in range(4):
		var offsetY = 7+order[i][0]-1 #- (2*order[i][0]-1)*pad
		var offsetX = (offsetY*order[i][1])/sqrt(3) #- order[i][1]*pad
		coords[i] = Vector2(offsetX,offsetY)*global.poly_size
	draw_polyline_colors(coords,PoolColorArray([Color(1,1,1)]),20,1)

func _process(delta):
	if global.dt < turn_start + global.move_time_new:
		global_rotation = (rot_int - angVel + angVel*sin((global.dt-turn_start)/global.move_time_new*PI/2))*PI/3
	else:
		global_rotation = rot_int*PI/3
#	var moveDir = fposmod(global_rotation/PI*3 - float(rot_int) ,6)
#	if moveDir > 3:
#		moveDir = moveDir-6
#	moveDir = moveDir*delta/global.move_time
#	global_rotation -= moveDir

func _input(event):
	var advance = 0
	keyID = -1
	if event.is_action_pressed("rotate_right"):
		keyID = 0
		angVel = 1
		rot_int = fposmod(rot_int+angVel,6)
		turn_start = global.dt
		advance = 1
	if event.is_action_pressed("rotate_left"):
		keyID = 1
		angVel = -1
		rot_int = fposmod(rot_int+angVel,6)
		turn_start = global.dt
		advance = 1
	if event.is_action_pressed("collect") :
		keyID = 2
		get_tree().call_group("balls", "get_collected", rot_int)
		#global.start_step = 1
	if event.is_action_pressed("progress"):
		keyID = 3
		advance = 1
		global.start_step = 1
		get_tree().get_root().get_node("game").get_node("sw_border").hide()
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_node("game").save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	if keyID >= 0:
		log_data()
		if advance*global.start_step:
			get_tree().call_group("balls", "step")
		#get_tree().get_root().get_node("game").go(advance*global.start_step)

func log_data():
	data_line["ke_time"] = global.dt
	data_line["ke_pos"] = rot_int
	#data_line["ke_pos_vis"] = global_rotation/PI*3
	data_line["ke_ID"] = keyID
	data_line["ke_startstep"] = global.start_step
	for key in data_line.keys():
		global.data[key].push_back(data_line[key])
	