extends Node2D

func init(lev):
	global.curr_wv = lev
	global.dt = 0
	global.score = 0
	global.start_step = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], "ba_ID_mv":[], "ba_time_mv":[], 
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev}

#ON START:
func _ready():
	$Spawner.mySpawn()
	#pass #set_process(true)
	#global.curr_wv = m

#EVERY FRAME(DT):
func _process(delta):
	global.dt += delta
	$Label2.set_text("Time: "+ str(floor(global.dt)) + " s")
	#$Label4.set_text("Percent: "+ str(round(float(global.score)/max(1,float(global.running_max))*100)) + " %")
	$Label.set_text("Score: "+ str(global.score)) # + " over par")
	$Label3.set_text("Wave: "+ str($Spawner.sw) + " of " + str(int($Spawner.arr[$Spawner.arr.size()-1][2])))

func go(advance):
	if advance:
		get_tree().call_group("balls", "step")
	var get_len = get_tree().get_nodes_in_group("balls").size()
	if  get_len == 0:
		$Spawner.mySpawn()