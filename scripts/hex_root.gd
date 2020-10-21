extends Node

#var HTTP = HTTPClient.new()
#var prt = 80
#var is_saving = 0
var game_scene = load("res://scenes/game.tscn")
var game_instance
var menu_scene = load("res://scenes/hex_menu.tscn")#hex_menu.tscn")
var menu_instance
var hex_slide_scene = load("res://scripts/hex_slider.gd")
var hex_slide_instance
var survey_scene = load("res://scenes/survey1.tscn")
var survey_instance
var perm_instance
var device_ID = Vector2(0,0)
var total_saves = 0
var in_lab = 0
var twn = Tween.new()
var url = "/upload/gd.php"
var IP = "http://95.179.150.62"
var compliments = PoolStringArray(["MONOMENTAL","DUOLICIOUS","TRIUMPHANT","TETRIFIC","PENTASTIC","HEXQUISITE"])
var file_to_delete = ""
var file = File.new()


func _ready():
	randomize()
	AudioServer.set_bus_volume_db(0,-10)
	$spiccato.volume_db = -5
	$spiccatoB.volume_db = 0
	if file.file_exists("user://levelscores"):
		file.open_compressed("user://levelscores",File.READ)
		for i in range(12):
			global.level_scores[i] = file.get_64()
			if !i%2 and global.level_scores[i] >= 0:
				global.max_level = i/2 + 1
		file.close()
		update_score()
	#if file.file_exists("user://hiscores"):
	#	file.open_compressed("user://hiscores",File.READ)
	#	global.max_level = file.get_32()
	#	file.close()
	if file.file_exists("user://save_count"):
		file.open_compressed("user://save_count",File.READ)
		total_saves = file.get_32()
		file.close()
	if !file.file_exists("user://deviceID"):
		var perm_scene = load("res://scenes/permission.tscn")
		perm_instance = perm_scene.instance()
		add_child(perm_instance)
	else:
		start_game()
	for i in range(6):
		for j in range(2):
			hex_slide_instance = hex_slide_scene.new()
			add_child(hex_slide_instance)
			hex_slide_instance.create(i,j)

func start_game():
	if !file.file_exists("user://deviceID"):
		gen_ID()
	else:
		file.open_compressed("user://deviceID",File.READ)
		device_ID.x = file.get_32()
		device_ID.y = file.get_32()
		file.close()
	add_child(twn)
	twn.start()
	twn.interpolate_method(self,"play_timed_midi",48,72,3.4)
	twn.interpolate_callback($lose,3.4,"play")
	$data_send.search_and_send()
	new_menu()
	#twn.set_tween_process_mode(0)

func start_survey():
	get_tree().call_group("hex_slider","hide")
	menu_instance.queue_free()
	survey_instance = survey_scene.instance()
	add_child(survey_instance)

func new_menu():
	menu_instance = menu_scene.instance()
	add_child(menu_instance)

func gen_ID():
	file.open_compressed("user://deviceID",File.WRITE)
	device_ID = Vector2(OS.get_unix_time(),randi())
	file.store_32(device_ID.x)
	file.store_32(device_ID.y)
	file.close()

func start_level(lobe):
#	is_saving = 0
	if lobe == 6:
		global.fail_thresh = 6
		global.make_rand = 2
		global.repeat_bad = 2
	else:
		global.fail_thresh = 15#*(fmod(device_ID.y,4)+1)
		global.make_rand = 2#min(2,fmod(int(device_ID.y)/4,4))
		global.repeat_bad = 2#min(2,fmod(int(device_ID.y)/16,4))
	game_instance = game_scene.instance()
	global.init(lobe,device_ID,total_saves)
	add_child(game_instance)
	menu_instance.queue_free()

func write_data():
	file.open("user://data" + global.save_file_name +".json", File.WRITE)
	file.store_line(to_json(global.data))
	file.close()

func save_data(win,end_level=true,user_quit=false,num_perfect=-1):
#	if !is_saving:
#		is_saving = 1
	#if !in_lab:
	total_saves += 1
	file.open_compressed("user://save_count",File.WRITE)
	file.store_32(total_saves)
	file.close()
	global.data["level_end_time"] = OS.get_ticks_msec()
	global.data["total_saves"] = total_saves
	global.data["level_won"] = win
	global.data["user_quit"] = user_quit
	write_data()
	if win:
		var file1 = File.new()
		#global.max_level = max(global.max_level,global.curr_wv)
		var total_time = global.data["level_end_time"] - global.data["sw_time"][0]
		if global.level_scores[global.curr_wv*2-2] < num_perfect or \
			(global.level_scores[global.curr_wv*2-2] == num_perfect and \
			global.level_scores[global.curr_wv*2-1] > total_time):
				file1.open_compressed("user://levelscores",File.WRITE)
				global.level_scores[global.curr_wv*2-2] = num_perfect
				global.level_scores[global.curr_wv*2-1] = total_time
				update_score()
				global.max_level = max(global.curr_wv,global.max_level)
				for i in range(12):
					file1.store_64(global.level_scores[i])
				file1.close()
		#file1.open_compressed("user://hiscores",File.WRITE)
		#file1.store_32(global.max_level)
		#file1.close()
	$data_send.search_and_send()
	if end_level:
		end_seq(win)
		game_instance.queue_free()

#func send_data(QUERYloc,fname):
#	var HEADERS = ["Content-Type: application/json", str("ID:",device_ID[0],"_",device_ID[1]) , str("SESSIONID:",fname)]
#	return $data_send.request_wrapper(IP + url, HEADERS,true,HTTPClient.METHOD_POST,QUERYloc,fname)

func end_seq(win):
	get_tree().call_group("hex_slider","hide")
	#var lbl = Label.new()
	#lbl.valign = Label.VALIGN_CENTER
	#lbl.align = Label.ALIGN_CENTER
	$end_label.rect_size = Vector2(global.w,global.h)
	$end_label.rect_scale = Vector2(0,0)
	#lbl.rect_position = Vector2(0,0)
	$end_label.rect_pivot_offset = Vector2(global.w,global.h)/2
	#lbl.rect_rotation = 270
	global.fnt.size = 80
	$end_label.set("custom_fonts/font",global.fnt)
	twn.start()
	if win:
		$end_label.set("custom_colors/font_color",global.hex_color(6,1))
		$end_label.text = "YOU ARE\n" + compliments[global.curr_wv-1] + "!"
		if game_instance.get_node("progress_tween").play_state.z == global.sw_count:
			timed_play(global.move_time_new,$spiccato,$spiccatoB,99999999)
		else:
			timed_play(global.move_time_new,$spiccato,$spiccatoB,game_instance.get_node("progress_tween").play_state.z-1)
		if global.curr_wv < 6:
			$end_label.text += "\nLEVEL " + str(global.curr_wv+1) + " UNLOCKED."
	else:
		$end_label.set("custom_colors/font_color",global.hint_color(7))
		$end_label.text = "YOU GOT\nHEXXED!"
		twn.interpolate_callback($lose,global.move_time_new,"play")
	#twn.interpolate_property(global.fnt,"size",1,80,global.move_time_new,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	twn.interpolate_property($end_label,"rect_scale",Vector2(0,0),Vector2(1,1),global.move_time_new,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	$end_label.show()
	#call_deferred("add_child",lbl)#add_child(lbl)
	twn.interpolate_callback(self,global.move_time_new*12,"new_menu")
	twn.interpolate_callback($end_label,global.move_time_new*12,"hide")
	#twn.interpolate_callback(lbl,global.move_time_new*12,"queue_free")

func timed_play(st = 0,  treb_stream = $spiccato,bass_stream = $spiccatoB,z = 0):
	var st_t
	var play_state = Vector3(0,0,z)
	var notesB = game_instance.get_node("Spawner").notesB
	var notesT = game_instance.get_node("Spawner").notesT
	while play_state.x < notesB.size() and notesB[play_state.x].y < (play_state.z+1)*global.measure_time:
		st_t = st+ (notesB[play_state.x].y)/global.measure_time*global.game_measure
		twn.interpolate_callback(self,st_t,"play_timed_midi",notesB[play_state.x].x,bass_stream,1)
		play_state.x += 1
	while play_state.y < notesT.size() and notesT[play_state.y].y < (play_state.z+1)*global.measure_time:
		st_t = st+ (notesT[play_state.y].y)/global.measure_time*global.game_measure
		twn.interpolate_callback(self,st_t,"play_timed_midi",notesT[play_state.y].x,treb_stream)
		play_state.y += 1
	play_state.z += 1

func play_timed_midi(pitch,stream = $spiccato,offset = 0):
	stream.pitch_scale = pow(2,pitch/12.0-5+offset)
	stream.play()
	
func update_score():
	global.total_score = 0
	for i in range(6):
		if global.level_scores[i*2] >= 0:
			global.total_score = global.total_score + 1000*global.level_scores[i*2] + \
			(1000*int(global.move_time_new*1000)*global.num_waves[i]*6*(i+1))/global.level_scores[i*2+1]

#func _on_data_send_request_completed(_result, _response_code, _headers, body,fname):
#	#if body.get_string_from_utf8() != "upload successful" and file_to_delete == "": #result != HTTPRequest.RESULT_SUCCESS and 
#	#	var file = File.new()
#	#	file.open("user://data" + global.save_file_name +".json", file.WRITE)
#	#	file.store_line(QUERY)
##		file.close()
#	if body.get_string_from_utf8() == "upload successful":#else:
#		var dir = Directory.new()
#		dir.open("user://")
#		dir.remove(fname)#file_to_delete)
#		dir.list_dir_begin()
#		var file_iter = dir.get_next()
#		while !file_iter.begins_with("data") and file_iter != "":
#			file_iter = dir.get_next()
#		#file_to_delete = file_iter
#		if file_iter.begins_with("data"):
#			var file = File.new()
#			file.open("user://" + file_iter,file.READ)
##			send_data(file.get_as_text(),file_iter.left(file_iter.length()-5).right(4))
#			file.close()
#		dir.list_dir_end()
