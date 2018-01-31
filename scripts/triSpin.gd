extends Node2D

var rot_int = 3
var rot_int_new = rot_int
var angVel = 0
var turn_start = 0
var data_line = {"ke_time":0, "ke_pos":0, "ke_ID":0, "ke_startstep":0} #"ke_pos_vis":0,
var data_line_mo = {"mo_time":0,"mo_x":0, "mo_y":0}
var keyID
var order = [[0,1],[6,1],[6,-1],[0,-1]]

func _ready():
	set_process_input(true)
	global_rotation = 0
	position = global.centre
#	set_z(1)
	
func _draw():
	var coords = PoolVector2Array()
	coords.resize(4)
	for i in range(4):
		var offsetY = 7+order[i][0]-1
		var offsetX = (offsetY*order[i][1])/sqrt(3)
		coords[i] = Vector2(offsetX,offsetY)*global.poly_size
	draw_polyline_colors(coords,PoolColorArray([Color(1,1,1)]),20,1)

func _process(delta):
	if global.dt < turn_start + global.move_time_new:
		global_rotation = (rot_int - angVel*sin((global.dt-turn_start)/global.move_time_new*PI/2))*PI/3 #-angVel for keyboard
	else:
		rot_int = fposmod(rot_int - angVel,6)
		if rot_int != rot_int_new:
			turn_start = global.dt
			if global.start_step:
				get_tree().call_group("balls", "step")
		else:
			angVel = 0
		global_rotation = rot_int*PI/3
#	var moveDir = fposmod(global_rotation/PI*3 - float(rot_int) ,6)
#	if moveDir > 3:
#		moveDir = moveDir-6
#	moveDir = moveDir*delta/global.move_time
#	global_rotation -= moveDir

func _input(event):
	var advance = 0
	keyID = -1
	if event is InputEventScreenTouch and event.pressed and global.dt > turn_start + global.move_time_new:
		log_data_mo(event.position-position)
		#if(event.button_index == 1):
		var clickPos
		clickPos = take_action(event.position)
		if clickPos[1] == 0:
			get_tree().call_group("balls", "get_collected", rot_int)
		if clickPos[1] == 1:
			#rot_int_old = rot_int
			rot_int_new = clickPos[0]
			if rot_int == rot_int_new:
				advance = 1
				global.start_step = 1
				get_tree().get_root().get_node("game").get_node("sw_border").hide()
			else:
				turn_start = global.dt
				advance = 1
				angVel = calc_ang_vel(rot_int,rot_int_new)
		if advance*global.start_step:
			get_tree().call_group("balls", "step")
	if event.is_action_pressed("rotate_right") and global.dt > turn_start + global.move_time_new:
		keyID = 0
		angVel = -1
		rot_int_new = fposmod(rot_int-angVel,6)
		turn_start = global.dt
		advance = 1
	if event.is_action_pressed("rotate_left") and global.dt > turn_start + global.move_time_new:
		keyID = 1
		angVel = 1
		rot_int_new = fposmod(rot_int-angVel,6)
		turn_start = global.dt
		advance = 1
	if event.is_action_pressed("collect") and global.dt > turn_start + global.move_time_new:
		keyID = 2
		get_tree().call_group("balls", "get_collected", rot_int)
		#global.start_step = 1
	if event.is_action_pressed("progress") and global.dt > turn_start + global.move_time_new:
		keyID = 3
		advance = 1
		global.start_step = 1
		get_tree().get_root().get_node("game").get_node("sw_border").hide()
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_node("game").save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	if keyID >= 0:
		log_data_ke()
		if advance*global.start_step:
			get_tree().call_group("balls", "step")

func calc_ang_vel(curr_loc,new_loc):
	if curr_loc == new_loc:
		return 0
	elif fposmod(curr_loc-new_loc,6) > 3:
		return -1
	else:
		return 1

func take_action(click_loc):
	var rel = click_loc - position
	var lobe = fposmod(6-round(atan2(rel.x,rel.y)/PI*3),6)
	var lobe_angle = (lobe)*PI/3
	var dist = sin(-lobe_angle)*rel.x+cos(-lobe_angle)*rel.y
	return [lobe,floor(dist/global.poly_size/6)]

func log_data_mo(mo_pos):
	data_line_mo["mo_time"] = global.dt
	data_line_mo["mo_x"] = mo_pos.x
	data_line_mo["mo_y"] = mo_pos.y
	for key in data_line_mo.keys():
		global.data[key].push_back(data_line_mo[key])

func log_data_ke():
	data_line["ke_time"] = global.dt
	data_line["ke_pos"] = rot_int
	#data_line["ke_pos_vis"] = global_rotation/PI*3
	data_line["ke_ID"] = keyID
	data_line["ke_startstep"] = global.start_step
	for key in data_line.keys():
		global.data[key].push_back(data_line[key])
	