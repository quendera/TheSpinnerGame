extends Node2D

func _ready():
	position = global.centre
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _draw():
	for i in range(0,3):
		var offsetY = sin(i*PI/3)*global.poly_size*12*2/sqrt(3)
		var offsetX = cos(i*PI/3)*global.poly_size*12*2/sqrt(3)
		self.draw_line(Vector2(-offsetX,-offsetY),Vector2(offsetX,offsetY),Color(0,0,0),5)
	var coords = PoolVector2Array()
	coords.resize(7)
	for i in range(12):
		for j in range(7):
			coords[j] = Vector2(cos(j*PI/3)*global.poly_size*(i+1),sin(j*PI/3)*global.poly_size*(i+1))*2/sqrt(3)
		self.draw_polyline_colors(coords,PoolColorArray([Color(0,0,0)]),5)