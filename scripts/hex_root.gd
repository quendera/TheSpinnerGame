extends Node

var HTTP = HTTPClient.new()
var prt = 80
var QUERY
var is_saving = 0
var game_scene = load("res://scenes/game.tscn")
var game_instance
var menu_scene = load("res://scenes/hex_menu.tscn")#hex_menu.tscn")
var menu_instance
var hex_slide_scene = load("res://scripts/hex_slider.gd")
var hex_slide_instance
var device_ID = Vector2(0,0)
var in_lab = 0
var twn = Tween.new()
var url = "/upload.php"
var IP = "http://95.179.150.62"
var compliments = PoolStringArray(["MONOMENTAL","DUOLICIOUS","TRIUMPHANT","TETRIFIC","PENTASTIC","HEXQUISITE"])
var file_to_delete = ""

func _ready():
	randomize()

	# The API used below is only available starting with Godot 3.1
	var version = Engine.get_version_info()
	if version.major > 3 || (version.major == 3 && version.minor >= 1):
		# GLES2 renders a black screen if WorldEnvironment background mode is "Canvas"
		if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
			$WorldEnvironment.environment.background_mode = Environment.BG_CLEAR_COLOR

	AudioServer.set_bus_volume_db(0,-10)
	$spiccato.volume_db = -5
	$spiccatoB.volume_db = 0
	var file = File.new()
	if !file.file_exists("user://deviceID"):
		file.open_compressed("user://deviceID",File.WRITE)
		device_ID = Vector2(OS.get_unix_time(),randi())
		file.store_32(device_ID.x)
		file.store_32(device_ID.y)
		file.close()
	else:
		file.open_compressed("user://deviceID",File.READ)
		device_ID.x = int(file.get_32())
		device_ID.y = int(file.get_32())
		file.close()
	if file.file_exists("user://hiscores"):
		file.open_compressed("user://hiscores",File.READ)
		global.max_level = int(file.get_32())
		file.close()
	#global.max_level = 5
#	if in_lab:
#		add_child(load("res://scripts/eye_calib.gd").new())
	for i in range(6):
		for j in range(2):
			hex_slide_instance = hex_slide_scene.new()
			add_child(hex_slide_instance)
			hex_slide_instance.create(i,j)
	new_menu()
	add_child(twn)
#	if 1:
#		var pop_ups = load("res://scripts/permission.gd").new()
#		add_child(pop_ups)

func new_menu():
	menu_instance = menu_scene.instance()
	add_child(menu_instance)

func start_level(lobe):
	is_saving = 0
	if lobe == 6:
		global.fail_thresh = 9
		global.make_rand = 2
		global.repeat_bad = 2
	else:
		global.fail_thresh = 18#*(fmod(device_ID.y,4)+1)
		global.make_rand = 2#min(2,fmod(int(device_ID.y)/4,4))
		global.repeat_bad = 2#min(2,fmod(int(device_ID.y)/16,4))
	game_instance = game_scene.instance()
	global.init(lobe,device_ID)
	add_child(game_instance)
	menu_instance.queue_free()

func save_data(win):
	if !is_saving:
		is_saving = 1
		if !in_lab:
			QUERY = to_json(global.data)
			send_data(QUERY,global.save_file_name)
#			if send_data(QUERY) != HTTPRequest.RESULT_SUCCESS: #HTTP.get_status() != HTTPClient.STATUS_BODY:
#				var file = File.new()
#				file.open(global.save_file_name, file.WRITE)
#				file.store_line(QUERY)
#				file.close()
		if win:
			var file = File.new()
			global.max_level = max(global.max_level,global.curr_wv)
			file.open_compressed("user://hiscores",File.WRITE)
			file.store_32(global.max_level)
			file.close()
		end_seq(win)
		game_instance.queue_free()

func send_data(QUERY,fname):
	var HEADERS = ["Content-Type: application/json", str("ID:",device_ID[0],"_",device_ID[1]) , str("SESSIONID:",fname)]
	return $data_send.request(IP + url, HEADERS,true,HTTPClient.METHOD_POST,QUERY)

#func send_data_old(QUERY):
#	var error = HTTP.connect_to_host(IP, prt)
#	var counter = 0
#	while HTTP.get_status() <= 4 and counter < 5:
#		HTTP.poll()
#		print(HTTP.get_status())
#		OS.delay_msec(50)
#		counter += 1
#	if HTTP.get_status() == HTTPClient.STATUS_CONNECTED:
#		var HEADERS = ["Content-Type: application/json", str("ID:",device_ID[0],"_",device_ID[1]) , str("SESSIONID:",OS.get_unix_time())]
#		HTTP.request(HTTPClient.METHOD_POST, url, HEADERS, QUERY)
#		counter = 0
#		while HTTP.get_status() == HTTPClient.STATUS_REQUESTING and counter < 5:
#			HTTP.poll()
#			print(HTTP.get_status())
#			print(HTTP.get_response_headers())
#			OS.delay_msec(50)
#			counter += 1
#	return HTTP.get_status()
#
#func send_data_from_directory():
#	#var files = []
#	var dir = Directory.new()
#	dir.open("user://")
#	dir.list_dir_begin()
#	var file = File.new()
#	while true:
#		var filename = dir.get_next()
#		if filename == "":
#			break
#		elif filename.begins_with("data"):
#			file.open("user://" + filename,file.READ)
#			if send_data(file.get_as_text()) == HTTPClient.STATUS_BODY:
#				dir.remove(filename)
#			else:
#				file.close()
#				break
#			#print( file.get_as_text())
#			file.close()
#			#break
#            #files.append(file)
#	dir.list_dir_end()

func end_seq(win):
	get_tree().call_group("hex_slider","hide")
	var lbl = Label.new()
	lbl.valign = Label.VALIGN_CENTER
	lbl.align = Label.ALIGN_CENTER
	lbl.rect_size = Vector2(global.w,global.h)
	lbl.rect_position = Vector2(0,0)
	global.fnt.size = 1
	lbl.set("custom_fonts/font",global.fnt)
	twn.start()
	if win:
		lbl.set("custom_colors/font_color",global.hex_color(6,1))
		lbl.text = "YOU ARE\n" + compliments[global.curr_wv-1] + "!"
		if game_instance.get_node("progress_tween").play_state.z == global.sw_count:
			timed_play(global.move_time_new,$spiccato,$spiccatoB,99999999)
		else:
			timed_play(global.move_time_new,$spiccato,$spiccatoB,game_instance.get_node("progress_tween").play_state.z-1)
		if global.curr_wv < 6:
			lbl.text += "\nLEVEL " + str(global.curr_wv+1) + " UNLOCKED."

	else:
		lbl.set("custom_colors/font_color",global.hint_color(7))
		lbl.text = "YOU GOT\nHEXXED!"
		twn.interpolate_callback($lose,global.move_time_new,"play")
	twn.interpolate_property(global.fnt,"size",1,80,global.move_time_new,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	add_child(lbl)
	twn.interpolate_callback(self,global.move_time_new*12,"new_menu")
	twn.interpolate_callback(lbl,global.move_time_new*12,"queue_free")

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

func play_timed_midi(pitch,stream,offset = 0):
	stream.pitch_scale = pow(2,pitch/12.0-5+offset)
	stream.play()

func _on_data_send_request_completed(result, response_code, headers, body):
	if body.get_string_from_utf8() != "upload successful" and file_to_delete == "": #result != HTTPRequest.RESULT_SUCCESS and 
		print("bad")
		var file = File.new()
		file.open("user://data" + global.save_file_name +".json", file.WRITE)
		file.store_line(QUERY)
		file.close()
	else:
		var dir = Directory.new()
		dir.open("user://")
		dir.remove(file_to_delete)
		dir.list_dir_begin()
		var file_iter = dir.get_next()
		while !file_iter.begins_with("data") and file_iter != "":
			file_iter = dir.get_next()
		file_to_delete = file_iter
		if file_iter.begins_with("data"):
			var file = File.new()
			file.open("user://" + file_to_delete,file.READ)
			send_data(file.get_as_text(),file_to_delete.left(file_to_delete.length()-5).right(4)+"old")
			file.close()
		dir.list_dir_end()
