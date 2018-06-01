extends Node2D

func _ready():
	pass

func _draw():
	for i in range(2):
		for j in range(2):
			draw_colored_polygon(global.full_hex(global.poly_size/2,0,Vector2(i*global.w + pow(-1,i)*global.poly_size,j*global.h + pow(-1,j)*global.poly_size*sqrt(3)/2)),Color(1,0,0))