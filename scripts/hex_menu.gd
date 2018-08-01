extends Node2D

var menu_label_scene = load("res://scripts/menu_label.gd")
var menu_label_instance
var menu_level_scene = load("res://scripts/menu_levels.gd")
var menu_level_instance
var menu_items = PoolStringArray(["SURVEY","ABOUT","PERFECT\nMODE","PLAY","SHARE","LEADER\nBOARD"])
var menu_items_lab = PoolStringArray(["CALIB-\nRATION","","","PLAY","",""])
#var startLevel

func _ready():
	global.fnt.font_data = load("res://assets/batmfa__.ttf")
	global.fnt.size = 40*global.h/720.0
	global.fnt.use_filter = true
	#OS.shell_open(hexxed)#"http://godotengine.org")
	for i in range(6):
		menu_label_instance = menu_label_scene.new()
		add_child(menu_label_instance)
		if $"..".in_lab:
			menu_label_instance.create(i,menu_items_lab[i])
		else:
			menu_label_instance.create(i,menu_items[i])
		menu_level_instance = menu_level_scene.new()
		add_child(menu_level_instance)
		menu_level_instance.create(i)
	$menu_tween.reset_hints()
	
#func start_level(lobe):
#	if lobe == 6:
#		global.fail_thresh = 9
#	startLevel = preload("res://scenes/game.tscn").instance()
#	startLevel.init(lobe,device_ID)
#	$menu_tween.interpolate_callback($"..",global.move_time_new,"add_child",startLevel)
#	$menu_tween.interpolate_callback(self,global.move_time_new,"queue_free")#remove_child")

#func _on_game_over():
#	if global.score > global.hi_scores[global.curr_wv-1]:
#		global.hi_scores[global.curr_wv-1] = global.score
#	file.open_compressed("user://hiscores",File.WRITE)
#	for i in range(global.hi_scores.size()):
#		file.store_32((global.hi_scores[i]))
#	file.close()
#	startLevel.queue_free()