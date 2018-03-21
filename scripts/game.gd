extends Node2D

var circScale = 34
var pad = .1
var order = [[pad/2,pad,pad],[pad/2,1-pad,pad],[1-pad/2,1-pad,-pad],[1-pad/2,pad,-pad]]
#var poly_class = preload("res://scripts/trapCell.gd") #scenes/hexCell.tscn")
#var poly_instance
#var neon_grid = preload("res://assets/sprites/grid.png")

func init(lev,player_name):
	global.curr_wv = lev
	global.dt = 0
	global.total_time = 300+int(lev > 4)*300
	global.sw_score = 0
	global.score = 0
#	global.start_step = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"mo_time":[],"mo_x":[], "mo_y":[],"mo_press":[],"mo_lobe":[],"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], #"ba_ID_mv":[], "ba_time_mv":[], 
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(), 
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize":OS.get_screen_size(), "device_timezone":OS.get_time_zone_info(),
	"device_IP": IP.get_local_addresses(), "player_name": player_name}

func _ready():
	$Spawner.mySpawn()
#	for i in range(6):
#		var spritefrompreload = Sprite.new()
#		spritefrompreload.set_texture(neon_grid)
#		spritefrompreload.apply_scale(Vector2(.5,.5))
#		#pritefrompreload.region_enabled = true
#		#print(neon_grid.get_size())
#		spritefrompreload.offset = global.neon_offset#neon_grid.get_height()/2*.85)
#		spritefrompreload.rotate(i*PI/3) #pos(Vector2(100, 100))
#		var scale_trans = 180
#		spritefrompreload.translate(global.centre)# + Vector2(scale_trans*sin(i*PI/3),-scale_trans*cos(i*PI/3)))
#		add_child(spritefrompreload)
#	for i in range(12):
#		for j in range(6):
#			poly_instance = poly_class.new()
#			poly_instance.create(i,j)
#			add_child(poly_instance)

func _process(delta):
	if !$action_tween.is_active() and (get_tree().get_nodes_in_group("hex_balls").size()) == 0: #+ get_tree().get_nodes_in_group("hint_balls").size()
		$Spawner.mySpawn()
#		get_tree().call_group("score_poly", "report",$Spawner.sw)
	global.dt += delta
#	$Label2.set_text("Time: "+ str(global.total_time - floor(global.dt)) + " s")
#	$Label.set_text("Score: "+ str(global.score))
#	$Label3.set_text("Wave: "+ str($Spawner.sw) + " of " + str(int($Spawner.arr[$Spawner.arr.size()-1][2])))

func save_data():
	var file = File.new()
	file.open(global.save_file_name, file.WRITE)
	file.store_line(to_json(global.data))
	file.close()

#func go(advance):
#	if advance:
#		get_tree().call_group("balls", "step")
##	var get_len = get_tree().get_nodes_in_group("balls").size()
##	if  get_len == 0:
##		$score_poly.report(global.score) # global.score)

func _on_progress_tween_tween_completed( object, key ):
	pass # replace with function body


func _on_progress_tween_tween_step( object, key, elapsed, value ):
	pass # replace with function body
