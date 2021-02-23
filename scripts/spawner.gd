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
var sw_played = 0
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
var measure_times = [8,8,9,16,16,160]

func _ready():
	$"../..".twn.stop_all()
	var i = 0
	file.open("res://assets/files/spawn.txt", File.READ)
	var target_line
	while (!file.eof_reached()):
		target_line = file.get_csv_line()
		if target_line.size() > 1 and int(target_line[1]) == global.curr_wv:
			arr[i] = target_line
			i = i+1
	file.close()
#	var arr1 = {}
#	for i in range(6):
#		arr1[i] = [0, 1, i+1, 36]
#	arr = arr1
	ball_per_sw = int(arr[arr.size()-1][2])
	ball_per_sw = arr.size()/ball_per_sw
	read_music_time()
	balls_left = ball_per_sw
	global.sw_count = global.num_waves[ball_per_sw-1]#sw_order.size()
	sw_order = shuffleList(range(global.sw_count),int(arr[arr.size()-1][2])/global.sw_count)#range(ball_per_sw))
	var accum = 0
	accum_points.append(accum)
	for j in range(global.sw_count):
		accum += int(arr[sw_order[j]*ball_per_sw][3])  
		accum_points.append(accum)
	global.max_score = accum
	mySpawn()

func shuffleList(list,offset):
	var shuffledList = []
	var indexList = range(list.size())
	for _i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[indexList[x]]*offset + randi()%offset)
		indexList.remove(x)
	return shuffledList

func mySpawn():
	#global.make_rand = 2 #JUST FOR DEBUGGING
	#global.repeat_bad = 2
	if sw_played >= global.sw_count:#sw_order.size():
		curr_wv_points = 0
		$"../..".save_data(true,true,false,$"../progress_tween".scale_count)
	else:
		#var rep_rand = global.repeat_bad == 1 and $"../progress_tween".num_fails > 0
		if (global.make_rand == 0 or (global.make_rand == 1 and ball_per_sw == 1)):# and !rep_rand:
			rand_offset = 0
			rand_flip = 0
		elif global.make_rand == 1: # and !rep_rand:
			input_i = sw_order[sw]*ball_per_sw + ball_per_sw - 1
			rand_offset = int(fposmod(-int(arr[input_i][0]),6))
			rand_flip = int(fposmod(int(arr[input_i][0])-int(arr[input_i-1][0]),6) > 3 or (ball_per_sw > 2 and fposmod(int(arr[input_i][0])-int(arr[input_i-1][0]),6) == 3 and fposmod(int(arr[input_i][0])-int(arr[input_i-2][0]),6) > 3)) 
		elif (global.make_rand == 2 and !(global.repeat_bad == 0 and $"../progress_tween".num_fails > 0)):# or rep_rand:
			rand_offset = randi() % 6
			rand_flip = randi() % 2
		$"../action_tween".rst()
		curr_wv_points = accum_points[sw+1]-accum_points[sw]
		$"../progress_tween".reset_hints()
		for i in range(ball_per_sw):
			input_i = sw_order[sw]*ball_per_sw + i
			send_rot = int(arr[input_i][0])
			send_rot = (send_rot+rand_offset)%6
			if rand_flip:
				send_rot = fposmod(-send_rot,6)
			hex_hint_instance = hex_hint_scene.new()
			hex_hint_instance.create(send_rot,i)
			add_child(hex_hint_instance)
			hex_target_instance = hex_target_scene.new()
			hex_target_instance.create(send_rot,i)
			add_child(hex_target_instance)
		#if ball_per_sw == 1 and $"..".has_node("hex_teacher"):# and sw == 0:
		#	$"../hex_teacher".set_pos(send_rot)
		log_data()
		sw += 1
		sw_played += 1

func log_data():
	global.data["sw_time"].push_back(OS.get_ticks_msec())
	global.data["sw_subwave_num"].push_back(sw_order[sw])
	global.data["sw_offset"].push_back(rand_offset)
	global.data["sw_flip"].push_back(rand_flip)

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		$"../..".save_data(false,true,true)
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		global.data["focus_in"].push_back(OS.get_ticks_msec())#print("focus in")
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		global.data["focus_out"].push_back(OS.get_ticks_msec())#print("focus out")
		$"../..".save_data(false,false)
		#get_tree().quit()

func read_music_time():#fname):
	file.open("res://assets/files/" + str(ball_per_sw) + ".txt", File.READ)
	var target_line
	while !file.eof_reached():
		target_line = file.get_csv_line()
		if target_line.size() == 4:
			if int(target_line[3]) == 1:
				notesT.push_back(Vector2(int(target_line[0]),float(target_line[1])))
			else:
				notesB.push_back(Vector2(int(target_line[0]),float(target_line[1])))
	file.close()
	global.measure_time = measure_times[ball_per_sw-1]#ball_per_sw-1] # 
	global.game_measure = 1.8 #2.5
	global.drone_measure = 2.4#5
