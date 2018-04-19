extends Node2D

var HTTP = HTTPClient.new()
var prt = 80
var is_saving = 0

func init(lev,player_name):
	global.curr_wv = lev
	#global.dt = 0
	global.total_time = 300+int(lev > 4)*300
	global.sw_score = 0
	global.score = 0
#	global.start_step = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"mo_time":[],"mo_x":[], "mo_y":[],"mo_press":[],"mo_lobe":[], #"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"mo_act_drag":[],"mo_move_time":[],"mo_move_pos_x":[],"mo_move_pos_y":[],
	"mo_act_taken_time":[],"mo_act_taken_act":[],"mo_act_taken_pos":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], #"ba_ID_mv":[], "ba_time_mv":[], 
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(), 
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize_x":OS.get_screen_size().x,"device_screensize_y":OS.get_screen_size().y, "device_timezone":OS.get_time_zone_info(),
	"device_IP": IP.get_local_addresses(), "player_name": player_name, 
	"OS_start_time": OS.get_ticks_msec()}

func _ready():
	$Spawner.mySpawn()

#func _process(delta):
	#if !$action_tween.is_active() and (get_tree().get_nodes_in_group("hex_balls").size()) == 0: #+ get_tree().get_nodes_in_group("hint_balls").size()
	#	$progress_tween.finish_hints()#$Spawner.mySpawn()
#		get_tree().call_group("score_poly", "report",$Spawner.sw)
#	global.dt += delta
#	$Label2.set_text("Time: "+ str(global.total_time - floor(global.dt)) + " s")
#	$Label.set_text("Score: "+ str(global.score))
#	$Label3.set_text("Wave: "+ str($Spawner.sw) + " of " + str(int($Spawner.arr[$Spawner.arr.size()-1][2])))

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
	
		var QUERY = HTTP.query_string_from_dict(global.data)
		var HEADERS = ["Content-Type: application/json"]
	
		HTTP.request(HTTPClient.METHOD_POST, url, HEADERS, QUERY) 
	
		while HTTP.get_status() == HTTPClient.STATUS_REQUESTING:
			HTTP.poll()
			print(HTTP.get_status())
			OS.delay_msec(50)
		
		#return to menu
		$"/root/menu_root"._on_game_over()