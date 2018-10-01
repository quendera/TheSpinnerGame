extends Node2D

var hex_hint_scene = preload("res://scripts/hex_hint.gd")
var hex_hint_instance
var hex_target_scene = preload("res://scripts/hex_target.gd")
var hex_target_instance
var input_i
var file = File.new()
var arr = {}
var notes = PoolIntArray()
var notesT = PoolVector2Array()
var notesB = PoolVector2Array()
var sw = 0
var sw_age = 0
var curr_wv_points
var rand_seq
var ball_per_sw
var balls_left
var sw_order
var score_grid = PoolVector2Array()
var accum_points = PoolIntArray()
var rand_offset
var rand_flip 
var send_rot

func _ready():
	var i = 0
	file.open("res://assets/files/spawn.txt", File.READ)
	var target_line
	while (!file.eof_reached()):
		target_line = file.get_csv_line()
		if target_line.size() > 1 and int(target_line[1]) == global.curr_wv:
			arr[i] = target_line
			i = i+1
	file.close()
#	read_music()
	read_music_time()
	ball_per_sw = int(arr[arr.size()-1][2])
	sw_order = shuffleList(range(ball_per_sw))
	ball_per_sw = arr.size()/ball_per_sw
	balls_left = ball_per_sw
	global.sw_count = sw_order.size()
	var accum = 0
	accum_points.append(accum)
	for i in range(global.sw_count):
		accum += int(arr[sw_order[i]*ball_per_sw][3])  
		accum_points.append(accum)
	mySpawn()

func shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func mySpawn():
	rand_offset = randi() % 6
	rand_flip = randi() % 2
	if sw >= sw_order.size():
		curr_wv_points = 0
		$"../..".save_data(true)
	else:
		$"../action_tween".rst()
		curr_wv_points = accum_points[sw+1]-accum_points[sw]
		$"../progress_tween".reset_hints()
		for i in range(ball_per_sw):
			input_i = sw_order[sw]*ball_per_sw + i
			send_rot = int(arr[input_i][0])
			if rand_flip:
				send_rot = (6-send_rot)
			send_rot = (send_rot+rand_offset)%6
			hex_hint_instance = hex_hint_scene.new()
			hex_hint_instance.create(send_rot,i)
			add_child(hex_hint_instance)
			hex_target_instance = hex_target_scene.new()
			hex_target_instance.create(send_rot,i)
			add_child(hex_target_instance)
		if ball_per_sw == 1 and $"..".has_node("hex_teacher"):# and sw == 0:
			$"../hex_teacher".set_pos(send_rot)
		log_data()
		sw += 1

func log_data():
	global.data["sw_time"].push_back(OS.get_ticks_msec())
	global.data["sw_subwave_num"].push_back(sw_order[sw])
	global.data["sw_offset"].push_back(rand_offset)
	global.data["sw_flip"].push_back(rand_flip)

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		$"../progress_tween".interpolate_callback($"../..",0,"save_data",false) #$"../..".save_data(false)
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		global.data["focus_in"].push_back(OS.get_ticks_msec())#print("focus in")
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		global.data["focus_out"].push_back(OS.get_ticks_msec())#print("focus out")
		#get_tree().quit()

func read_music_time():#fname):
	file.open("res://assets/files/jesu.txt", File.READ)
	var target_line
	while !file.eof_reached():
		target_line = file.get_csv_line()
		if target_line.size() == 4:
			if int(target_line[3]) == 1:
				notesT.push_back(Vector2(int(target_line[0]),float(target_line[1])))
			else:
				notesB.push_back(Vector2(int(target_line[0]),float(target_line[1])))
	file.close()
	global.measure_time = 9 # 5
	global.game_measure = 1.8 #2.5
	global.drone_measure = 2.4 #5