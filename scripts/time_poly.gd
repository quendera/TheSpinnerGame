extends Polygon2D

var radius = global.poly_size*6*2/sqrt(3)*.7
var hex_outline = PoolVector2Array()

func _ready():
	color = global.which_color(12)
	position = Vector2(global.w/5,global.h*.75)
	hex_outline = global.full_hex(radius,1)

func _draw():
	draw_polyline(hex_outline,Color(1,1,1)/2,2,1)

func _process(delta):
	var angle = (global.total_time - global.dt)/global.total_time*6 #
	if angle <= 0:
		$"..".save_data()
		get_tree().get_root().get_node("menu_root")._on_game_over()
	polygon = global.pie_hex(hex_outline,angle)