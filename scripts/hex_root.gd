extends Node

var HTTP = HTTPClient.new()
var prt = 80
var is_saving = 0
var game_scene = preload("res://scenes/game.tscn")
var game_instance
var menu_scene = preload("res://scenes/hex_menu.tscn")
var menu_instance
var hex_slide_scene = preload("res://scripts/hex_slider.gd")
var hex_slide_instance
var device_ID = Vector2(0,0)
var file = File.new()

func _ready():
	randomize()
	if !file.file_exists("user://deviceID"):
		file.open_compressed("user://deviceID",File.WRITE)
		device_ID = Vector2(OS.get_unix_time(),randi())
		file.store_32((device_ID.x))
		file.store_32((device_ID.y))
		file.close()
	else:
		file.open_compressed("user://deviceID",File.READ)
		device_ID.x = int(file.get_32())
		device_ID.y = int(file.get_32())
		file.close()
	if file.file_exists("user://hiscores"):
		file.open_compressed("user://hiscores",File.READ)
		for i in range(global.hi_scores.size()):
			global.hi_scores[i] = int(file.get_32())
		file.close()
	global.fail_thresh = 9*2#(fmod(device_ID.y,4)+1) #FOR NOW USING SAME THRESH FOR ALL PLAYERS
	for i in range(6):
		for j in range(2):
			hex_slide_instance = hex_slide_scene.new()
			add_child(hex_slide_instance)
			hex_slide_instance.create(i,j)
	menu_instance = menu_scene.instance()
	add_child(menu_instance)

func start_level(lobe):
	if lobe == 6:
		global.fail_thresh = 9
	game_instance = game_scene.instance()
	init(lobe)
	#game_instance.init(lobe,device_ID)
	add_child(game_instance)
	menu_instance.queue_free()

func init(lev):#,player_name = "",player_ID = 0):
	AudioServer.set_bus_volume_db(4,-35)
	AudioServer.set_bus_volume_db(6,-30)
	global.curr_wv = lev
	global.sw_score = 0
	global.score = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"mo_time":[],"mo_x":[], "mo_y":[],"mo_lobe":[], "mo_press_time":[], #"mo_press":[],"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"mo_act_drag":[],"mo_move_time":[],"mo_move_pos_x":[],"mo_move_pos_y":[],"mo_fake_release":[], #"mo_act_drag_time":[],
	"mo_act_taken_time":[],"mo_act_taken_act":[],"mo_act_taken_pos":[],"mo_press_x":[], "mo_press_y":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], #"ba_ID_mv":[], "ba_time_mv":[],
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(),
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize_x":OS.get_screen_size().x,"device_screensize_y":OS.get_screen_size().y,
	"device_timezone":OS.get_time_zone_info(),"device_dpi":OS.get_screen_dpi(),
	"device_IP": IP.get_local_addresses(),# "player_name": player_name,"player_ID":player_ID,
	"device_ID_time":device_ID.x,"device_ID_rand":device_ID.y,
	"OS_start_time": OS.get_ticks_msec(), "drone_play": [], "failure_thresh":global.fail_thresh}

func save_data():
	if !is_saving:
		is_saving = 1
		var file = File.new()
		file.open(global.save_file_name, file.WRITE)
		file.store_line(to_json(global.data))
		file.close()
		# SEND TO SERVER
		var url = "/post.php"
		var error = 0
		error = HTTP.connect_to_host("199.247.17.106", prt)
		assert(error == OK)

		while HTTP.get_status() == HTTPClient.STATUS_CONNECTING or HTTP.get_status() == HTTPClient.STATUS_RESOLVING:
			HTTP.poll()
			print(HTTP.get_status())
			OS.delay_msec(50)
		assert(HTTP.get_status() == HTTPClient.STATUS_CONNECTED)

		#var QUERY = HTTP.query_string_from_dict(global.data)
		var QUERY = to_json(global.data)
		var HEADERS = ["Content-Type: application/json"]

		HTTP.request(HTTPClient.METHOD_POST, url, HEADERS, QUERY)

		while HTTP.get_status() == HTTPClient.STATUS_REQUESTING:
			HTTP.poll()
			print(HTTP.get_status())
			OS.delay_msec(50)

		#update high scores
		if global.score > global.hi_scores[global.curr_wv-1]:
			global.hi_scores[global.curr_wv-1] = global.score
		file.open_compressed("user://hiscores",File.WRITE)
		for i in range(global.hi_scores.size()):
			file.store_32((global.hi_scores[i]))
		file.close()
		menu_instance = menu_scene.instance()
		add_child(menu_instance)
		game_instance.queue_free()
		is_saving = 0