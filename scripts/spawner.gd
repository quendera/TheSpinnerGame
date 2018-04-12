extends Node2D

var hex_hint_scene = preload("res://scripts/hex_hint.gd")
var hex_hint_instance
var hex_slide_scene = preload("res://scripts/hex_slider.gd")
var hex_slide_instance
var hex_target_scene = preload("res://scripts/hex_target.gd")
var hex_target_instance
var input_i
var file = File.new()
var arr = {}
var notes = PoolIntArray()
var sw = 0
var sw_age = 0
var curr_wv_points
var rand_seq
var ball_per_sw
var balls_left
var sw_order
var score_grid = PoolVector2Array()
#var data_line = {"sw_time":0, "sw_subwave_num":0, "sw_offset":0, "sw_flip" : 1}
var accum_points = PoolIntArray()

func _ready():
	randomize()
	var i = 0
	file.open("res://assets/files/spawn.txt", File.READ)
	var target_line
	while (!file.eof_reached()):
		target_line = file.get_csv_line()
		if target_line.size() > 1 and int(target_line[1]) == global.curr_wv:
			arr[i] = target_line
			i = i+1
	file.close()
	read_music()
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
	for i in range(6):
		for j in range(2):
			hex_slide_instance = hex_slide_scene.new()
			add_child(hex_slide_instance)
			hex_slide_instance.create(i,j)

#func _onready():
#	self.set_position($game.center)

func shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func mySpawn():
	var rand_offset = randi() % 6
	var rand_flip = randi() % 2
	if sw >= sw_order.size():
		curr_wv_points = 0
		#$"../progress_tween".reset_hints()
		$"..".save_data()
	else:
		$"../action_tween".reset()
		curr_wv_points = accum_points[sw+1]-accum_points[sw]
		$"../progress_tween".reset_hints()
		for i in range(ball_per_sw):
			input_i = sw_order[sw]*ball_per_sw + i
			var send_rot = int(arr[input_i][0])
			if rand_flip:
				send_rot = (6-send_rot)
			send_rot = (send_rot+rand_offset)%6
			hex_hint_instance = hex_hint_scene.new()
			hex_hint_instance.create(send_rot,i)
			add_child(hex_hint_instance)
			hex_target_instance = hex_target_scene.new()
			hex_target_instance.create(send_rot,i)
			add_child(hex_target_instance)
		log_data(rand_offset,rand_flip)
		sw += 1
	for i in range(6-ball_per_sw):
		get_tree().call_group("balls", "step")

func log_data(offset,flip):
	global.data["sw_time"].push_back(OS.get_ticks_msec())#global.dt
	global.data["sw_subwave_num"].push_back(sw_order[sw])
	global.data["sw_offset"].push_back(offset)
	global.data["sw_flip"].push_back(flip)
	#for key in data_line.keys():
	#	global.data[key].push_back(data_line[key])

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		get_tree().get_root().get_node("game").save_data()
		#get_tree().get_root().get_node("menu_root")._on_game_over()
		get_tree().quit()
		
func read_music():#fname):
	file.open("res://assets/files/bach.txt", File.READ)
	var target_line
	while (!file.eof_reached()):
		target_line = file.get_csv_line()
		if target_line.size() > 0:
			notes.push_back(int(target_line[0]))
	file.close()