extends Node2D

var hex_slide_scene = preload("res://scripts/hex_slider.gd")
var hex_slide_instance
var menu_label_scene = preload("res://scripts/menu_label.gd")
var menu_label_instance
var menu_level_scene = preload("res://scripts/menu_levels.gd")
var menu_level_instance
var menu_items = PoolStringArray(["SURVEY","ABOUT","HOW TO\nPLAY","PLAY","SHARE","LEADER\nBOARD"])
var device_ID = Vector2(0,0)
var file = File.new()
var startLevel

func _ready():
	var fnt = DynamicFont.new()
	fnt.font_data = load("res://assets/batmfa__.ttf")
	fnt.size = 40
	fnt.use_filter = true
	randomize()
	#OS.shell_open(hexxed)#"http://godotengine.org")
	for i in range(6):
		menu_label_instance = menu_label_scene.new()
		add_child(menu_label_instance)
		menu_label_instance.create(i,menu_items[i],fnt)
		menu_level_instance = menu_level_scene.new()
		add_child(menu_level_instance)
		menu_level_instance.create(i)
#		lbl.rect_pivot_offset = lbl.rect_size/2
#		#lbl.margin_top = 5#global.poly_size*10
		for j in range(2):
			hex_slide_instance = hex_slide_scene.new()
			add_child(hex_slide_instance)
			hex_slide_instance.create(i,j)
	if file.file_exists("user://hiscores"):
		file.open_compressed("user://hiscores",File.READ)
		for i in range(global.hi_scores.size()):
			global.hi_scores[i] = int(file.get_32())
		file.close()
#	$player_name.set_placeholder("Enter player name")
	if !file.file_exists("user://deviceID"):
		file.open_compressed("user://deviceID",File.WRITE)
		device_ID = Vector2(OS.get_unix_time(),randi())
		file.store_32((device_ID.x))# + "\n")
		file.store_32((device_ID.y))# + "\n")
		file.close()
	else:
		file.open_compressed("user://deviceID",File.READ)
		device_ID.x = int(file.get_32())
		device_ID.y = int(file.get_32())
		file.close()
	global.fail_thresh = 9*(fmod(device_ID.y,4)+1)
	$menu_tween.reset_hints()
	
func start_level(lobe):
	if lobe == 6:
		global.fail_thresh = 9
	startLevel = preload("res://scenes/game.tscn").instance()
	startLevel.init(lobe,device_ID)
	$menu_tween.interpolate_callback($"/root",global.move_time_new,"add_child",startLevel)
	$menu_tween.interpolate_callback($"/root",global.move_time_new*2,"remove_child",self)

func _on_game_over():
	if global.score > global.hi_scores[global.curr_wv-1]:
		global.hi_scores[global.curr_wv-1] = global.score
	file.open_compressed("user://hiscores",File.WRITE)
	for i in range(global.hi_scores.size()):
		file.store_32((global.hi_scores[i]))# + "\n")
	file.close()
	startLevel.queue_free()
	#update_access()