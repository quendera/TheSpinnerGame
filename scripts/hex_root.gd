extends Node

var HTTP = HTTPClient.new()
var prt = 80
var QUERY
#var is_saving = 0
var game_scene = load("res://scenes/game.tscn")
var game_instance
var menu_scene = load("res://scenes/hex_menu.tscn")#hex_menu.tscn")
var menu_instance
var hex_slide_scene = load("res://scripts/hex_slider.gd")
var hex_slide_instance
var perm_instance
var device_ID = Vector2(0,0)
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
	if file.file_exists("user://hiscores"):
		file.open_compressed("user://hiscores",File.READ)
		global.max_level = int(file.get_32())
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
		device_ID.x = int(file.get_32())
		device_ID.y = int(file.get_32())
		file.close()
	add_child(twn)
	twn.start()
	twn.interpolate_method(self,"play_timed_midi",48,72,3.4)
	twn.interpolate_callback($lose,3.4,"play")
	$data_send.search_and_send()
	new_menu()
	#twn.set_tween_process_mode(0)


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
	global.init(lobe,device_ID)
	add_child(game_instance)
	menu_instance.queue_free()

func save_data(win,end_level=true):
#	if !is_saving:
#		is_saving = 1
	if !in_lab:
		QUERY = to_json(global.data)
		var file1 = File.new()
		file1.open("user://data" + global.save_file_name +".json", file1.WRITE)
		file1.store_line(QUERY)
		file1.close()
		$data_send.search_and_send()
		#data_send_instance = data_send_scene.new()
		#call_deferred("add_child",data_send_instance)#
		#add_child(data_send_instance)
		#data_send_instance.create(global.save_file_name,device_ID,QUERY)
		#get_tree().call_group("file_to_send","request_wrapper")
		#send_data(QUERY,global.save_file_name)
#			if send_data(QUERY) != HTTPRequest.RESULT_SUCCESS: #HTTP.get_status() != HTTPClient.STATUS_BODY:
#				var file = File.new()
#				file.open(global.save_file_name, file.WRITE)
#				file.store_line(QUERY)
#				file.close()
	if win:
		var file1 = File.new()
		global.max_level = max(global.max_level,global.curr_wv)
		file1.open_compressed("user://hiscores",File.WRITE)
		file1.store_32(global.max_level)
		file1.close()
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
