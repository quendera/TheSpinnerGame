extends Node2D

#var ball_scene = preload("res://scenes/target.tscn")#scripts/target_grow.gd")#triBall.gd")
var ball_scene = preload("res://scripts/triBall.gd")
var ball_instance
var hex_hint_scene = preload("res://scripts/hex_hint.gd")
var hex_hint_instance
var hex_hint_slide_scene = preload("res://scripts/hex_hint_slide.gd")
var hex_hint_slide_instance
var hex_target_scene = preload("res://scripts/hex_target.gd")
var hex_target_instance
#var point_class = preload("res://scripts/score_triangle.gd")
#var point_instance
var input_i #= 0
var file = File.new()
var arr = {}
var sw = 0
var sw_age = 0
var rand_seq
var ball_per_sw
var sw_order
var score_grid = PoolVector2Array()
var data_line = {"sw_time":0, "sw_subwave_num":0, "sw_offset":0, "sw_flip" : 1}
var accum_points = PoolIntArray()
#var score_class = preload("res://scripts/score_poly.gd")
#var score_instance

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
	sw_order = range(ball_per_sw)#shuffleList(range(ball_per_sw))
	ball_per_sw = arr.size()/ball_per_sw
	global.sw_count = sw_order.size()
	file.close()
	var accum = 0
	accum_points.append(accum)
	for i in range(global.sw_count):
		accum += int(arr[sw_order[i]*ball_per_sw][3]) #6*6*ball_per_sw + 
		accum_points.append(accum)
	for i in range(ball_per_sw):
		hex_hint_slide_instance = hex_hint_slide_scene.new()
		hex_hint_slide_instance.create(0,i)
		add_child(hex_hint_slide_instance)
	#global.progress_rad = global.poly_size*20/sqrt(accum_points[-1])
#	for i in range(accum_points[-1]):
#		point_instance = point_class.new()#instance()
#		point_instance.create(i) #global.curr_wv, input_i)
#		add_child(point_instance)

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
	global.start_step = 0
	if sw >= sw_order.size():
		get_tree().get_root().get_node("game").save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	else:
		#$"../sw_border".show()
		$"../sw_border".make_col(global.which_color(12).inverted())
		$"../score_poly".sw_outline = $"../score_poly".total_outline
		$"../action_tween".reset()
		#score_instance = score_class.new()
		#score_instance.create(sw+1)
		#add_child(score_instance)
		#global.score += global.sw_score #max(-5,global.sw_score)
		#get_tree().call_group("score_triangle", "paint",accum_points[-1]-accum_points[sw],accum_points[-1]-accum_points[max(0,sw-1)]-global.sw_score,-1)
		global.sw_score = 0#-ball_per_sw*6-int(arr[sw_order[sw]*ball_per_sw][3]) + 6
		#print(global.pie_hex($"../score_total_poly".hex_outline,float(accum_points[sw])/accum_points[-1]*6))
		#$"../score_total_poly".polygon = global.pie_hex($"../score_total_poly".hex_outline,float(accum_points[sw+1])/accum_points[-1]*6)
		for i in range(ball_per_sw):
			input_i = sw_order[sw]*ball_per_sw + i
			var send_rot = int(arr[input_i][0])
			if rand_flip:
				send_rot = (6-send_rot)
			send_rot = (send_rot+rand_offset)%6
			get_tree().call_group("hint_slide", "set_next_pos",send_rot,i)
			# this is for new targets
#			hex_hint_instance = hex_hint_scene.new()
#			hex_hint_instance.create(send_rot,i)
#			add_child(hex_hint_instance)
			hex_target_instance = hex_target_scene.new()
			hex_target_instance.create(send_rot,i)
			add_child(hex_target_instance)
#			# this is the classical way
#			ball_instance = ball_scene.new()#instance() #
#			ball_instance.create(send_rot, sw, input_i) #global.curr_wv, input_i)
#			add_child(ball_instance)
#			get_tree().call_group("balls", "step")
		log_data(rand_offset,rand_flip) #also add scrambled sw?
		#get_tree().call_group("score_triangle", "paint",accum_points[-1]-accum_points[sw+1],accum_points[-1]-accum_points[sw],0)
		sw += 1
		$"../hint_tween".slide_hints()
		$"../score_poly".total_outline = global.spiral_peel(1 - float(accum_points[sw])/accum_points[-1])
		$"../score_poly".update()
	for i in range(6-ball_per_sw):
		get_tree().call_group("balls", "step")

func log_data(offset,flip):
	data_line["sw_time"] = global.dt
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