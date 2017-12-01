extends Node2D

func _ready():
	position = global.centre

func _draw():
	var coords = PoolVector2Array()
	coords.resize(7)
	for j in range(7):
		coords[j] = Vector2(cos(j*PI/3)*global.poly_size*6,sin(j*PI/3)*global.poly_size*6)*2/sqrt(3)
	self.draw_polyline_colors(coords,PoolColorArray([Color(1,1,1)]),5)
