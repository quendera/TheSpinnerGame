extends Node2D

var circScale = 34
var pad = .1
var order = [[pad/2,pad,pad],[pad/2,1-pad,pad],[1-pad/2,1-pad,-pad],[1-pad/2,pad,-pad]]
var poly_class = preload("res://scripts/trapCell.gd") #scenes/hexCell.tscn")
var poly_instance

func init(lev,player_name):
	global.curr_wv = lev
	global.dt = 0
	global.sw_score = 0
	global.score = 0
	global.start_step = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], "ba_ID_mv":[], "ba_time_mv":[], 
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(), 
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize":OS.get_screen_size(), "device_timezone":OS.get_time_zone_info(),
	"device_IP": IP.get_local_addresses(), "player_name": player_name}

func _ready():
	$Spawner.mySpawn()
	for i in range(12):
		for j in range(6):
			poly_instance = poly_class.new()
			poly_instance.create(i,j)
			add_child(poly_instance)

func _process(delta):
	if  get_tree().get_nodes_in_group("balls").size() == 0:# and global.sw_end_flag == 0:
		#$score_poly.report(global.sw_score)
		get_tree().call_group("score_poly", "report",$Spawner.sw)
	global.dt += delta
	$Label2.set_text("Time: "+ str(floor(global.dt)) + " s")
	$Label.set_text("Score: "+ str(global.score))
	$Label3.set_text("Wave: "+ str($Spawner.sw) + " of " + str(int($Spawner.arr[$Spawner.arr.size()-1][2])))

func save_data():
	var file = File.new()
	file.open(global.save_file_name, file.WRITE)
	file.store_line(to_json(global.data))
	file.close()

func go(advance):
	if advance:
		get_tree().call_group("balls", "step")
#	var get_len = get_tree().get_nodes_in_group("balls").size()
#	if  get_len == 0:
#		$score_poly.report(global.score) # global.score)