extends Node2D

#var ball_scene = preload("res://scenes/ball.tscn")
var ball_scene = preload("res://scripts/triBall.gd")
var ball_instance
var input_i #= 0
var file = File.new()
var arr = {}
var sw = 0
var rand_seq
var ball_per_sw
var sw_order
var data_line = {"sw_time":0, "sw_subwave_num":0, "sw_offset":0, "sw_flip" : 1}

#ON START:
func _ready():
	randomize()
	var i = 0
	file.open("res://assets/files/spawn.txt", File.READ)
	while (!file.eof_reached()):
		var target_line = file.get_csv_line()
		if target_line.size() > 1 and int(target_line[1]) == global.curr_wv:
			arr[i] = target_line
			i = i+1
	ball_per_sw = int(arr[arr.size()-1][2])
	sw_order = shuffleList(range(ball_per_sw))
	ball_per_sw = arr.size()/ball_per_sw
	file.close() 

func _onready():
	self.set_position($game.center)

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
	#var counter = 0
	global.start_step = 0
	if sw >= sw_order.size():
		get_tree().get_root().get_node("game").save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	else:
		get_tree().get_root().get_node("game").get_node("sw_border").show()
		for i in range(ball_per_sw):
			input_i = sw_order[sw]*ball_per_sw + i
			ball_instance = ball_scene.new()#instance()
			var send_rot = int(arr[input_i][0])
			if rand_flip:
				send_rot = (6-send_rot)
			send_rot = (send_rot+rand_offset)%6
			ball_instance.create(send_rot, sw, global.curr_wv, input_i)
			add_child(ball_instance)
			#counter += 1
			get_tree().call_group("balls", "step")
		log_data(rand_offset,rand_flip)
		#global.running_max += curr_wv*curr_wv + int(arr[input_i][3])
		sw += 1
	for i in range(6-ball_per_sw):
		get_tree().call_group("balls", "step")
	#while counter < 6:
	#	counter += 1
	#	get_tree().call_group("balls", "step")
	
func log_data(offset,flip):
	data_line["sw_time"] = global.dt #OS.get_unix_time()
	data_line["sw_subwave_num"] = sw_order[sw]
	data_line["sw_offset"] = offset
	data_line["sw_flip"] = flip
	for key in data_line.keys():
		global.data[key].push_back(data_line[key])

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		get_tree().get_root().get_node("game").save_data()
		#get_tree().get_root().get_node("menu_root")._on_game_over()
		get_tree().quit()