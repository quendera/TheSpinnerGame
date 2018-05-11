extends Node2D

var HTTP = HTTPClient.new()
var prt = 80
var is_saving = 0

func init(lev,player_name,player_ID,device_ID):
	AudioServer.set_bus_volume_db(4,-35)
	AudioServer.set_bus_volume_db(6,-30)
	global.curr_wv = lev
	global.sw_score = 0
	global.score = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"mo_time":[],"mo_x":[], "mo_y":[],"mo_press":[],"mo_lobe":[], #"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"mo_act_drag":[],"mo_act_drag_time":[],"mo_move_time":[],"mo_move_pos_x":[],"mo_move_pos_y":[],
	"mo_act_taken_time":[],"mo_act_taken_act":[],"mo_act_taken_pos":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], #"ba_ID_mv":[], "ba_time_mv":[], 
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(), 
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize_x":OS.get_screen_size().x,"device_screensize_y":OS.get_screen_size().y, 
	"device_timezone":OS.get_time_zone_info(),"device_dpi":OS.get_screen_dpi(),
	"device_IP": IP.get_local_addresses(), "player_name": player_name, 
	"player_ID":player_ID,"device_ID":device_ID,
	"OS_start_time": OS.get_ticks_msec(), "drone_play": [], "failure_thresh":$"progress_tween".fail_thresh}

func _ready():
	$Spawner.mySpawn()

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
		
		#return to menu
		$"/root/menu_root"._on_game_over()