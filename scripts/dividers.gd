extends Node2D

var coords = PoolVector2Array()
var dist = 0

func _ready():
	position = global.centre
	z_index = -2
	coords.resize(7)

func _draw():
	dist = fposmod($"../action_tween".wave_age,1)
	for i in range(6):
		coords = global.full_hex((global.poly_size*(i+dist)*2+global.side_offset)/sqrt(3),1)
		draw_polyline(coords,global.hint_color(i+dist),2) #Color(0,0,0)
	coords = global.full_hex((global.poly_size*6*2+global.side_offset)/sqrt(3),1)
	draw_polyline(coords,global.hint_color(6),2)