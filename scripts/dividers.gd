extends Node2D

var coords = PoolVector2Array()
var dist = 0

func _ready():
	position = global.centre
	z_index = -2
	coords.resize(7)

func _draw():
	dist = fmod($"../action_tween".wave_age,1)
#	for i in range(0,3):
#		var offsetY = sin(i*PI/3)*global.poly_size*12*2/sqrt(3)
#		var offsetX = cos(i*PI/3)*global.poly_size*12*2/sqrt(3)
#		self.draw_line(Vector2(-offsetX,-offsetY),Vector2(offsetX,offsetY),Color(0,0,0),5)#Color(0,0,0)
	for i in range(6):
		coords = global.full_hex(global.poly_size*(i+dist)*4/sqrt(3)+global.side_offset*2/sqrt(3),1)
		draw_polyline(coords,global.hex_color(i),2) #Color(0,0,0)
	coords = global.full_hex(global.poly_size*(6)*4/sqrt(3)+global.side_offset*2/sqrt(3),1)
	draw_polyline(coords,global.hex_color(6,true),2)