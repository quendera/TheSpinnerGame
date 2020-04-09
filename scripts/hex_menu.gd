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

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		#$"../..".save_data(false)
		get_tree().quit()
