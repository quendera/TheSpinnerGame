extends Node2D

func _ready():
	position = global.centre
	z_index = 0

func _draw():
	for i in range(0,3):
		var offsetY = sin(i*PI/3)*global.poly_size*12*2/sqrt(3)
		var offsetX = cos(i*PI/3)*global.poly_size*12*2/sqrt(3)
		self.draw_line(Vector2(-offsetX,-offsetY),Vector2(offsetX,offsetY),Color(0,0,0),5)#Color(0,0,0)
	var coords = PoolVector2Array()
	coords.resize(7)
	for i in range(12):
		coords = global.full_hex(global.poly_size*(i+1)*2/sqrt(3),1)
		var col = Color(.5,.5,.5)/8*int(i<6)
		col.a = 1
		self.draw_polyline(coords,col,2) #Color(0,0,0)