extends Node2D

var radius = global.poly_size*6*2/sqrt(3)*.7
var hex_outline = PoolVector2Array()
var color = global.which_color(12).inverted()
var coil_len = 1
var tick = 0

func _ready():
#	color = global.which_color(12)
	position = Vector2(global.w/5,global.h*.75)
	hex_outline = global.progress_spiral #full_hex(radius,1)

func _draw():
#	rotation = -hex_outline[-1].angle() - PI/2
	if hex_outline.size() > 1:
		draw_polyline(hex_outline,color,5,1)

func _process(delta):
	coil_len = (global.total_time - global.dt)/global.total_time # + float(global.score)/$"../Spawner".accum_points[-1]
	tick += delta
	hex_outline = global.spiral_peel(coil_len)
	if coil_len <= 0: #global.dt >= global.total_time:
		$"..".save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	if tick > 1:
		tick -= 1
		update()
#	var angle = (global.total_time - global.dt)/global.total_time*6 #
#	if angle <= 0:
#		$"..".save_data()
#		get_tree().get_root().get_node("menu_root")._on_game_over()
#	polygon = global.pie_hex(hex_outline,angle)
	
#func _ready():
#	color = global.which_color(12)
#	position = Vector2(global.w/5,global.h*.75)
#	hex_outline = global.full_hex(radius,1)
#
#func _draw():
#	draw_polyline(hex_outline,Color(1,1,1)/2,2,1)
#
#func _process(delta):
#	var angle = (global.total_time - global.dt)/global.total_time*6 #
#	if angle <= 0:
#		$"..".save_data()
#		get_tree().get_root().get_node("menu_root")._on_game_over()
#	polygon = global.pie_hex(hex_outline,angle)