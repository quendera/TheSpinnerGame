extends Node2D

var col = Color(1,1,1)/2#global.which_color(12)#Color(1,1,1)
var wid = 5

func _ready():
	position = global.centre
	z_index = 0

func _draw():
	var coords = PoolVector2Array()
	coords.resize(7)
	var coords1 = PoolVector2Array()
	coords1.resize(7)
	for j in range(7):
		coords[j] = Vector2(cos(j*PI/3)*global.poly_size*6,sin(j*PI/3)*global.poly_size*6)*2/sqrt(3)
	draw_polyline(coords,col,wid)
#	for j in range(7):
#		coords1[j] = Vector2(cos(j*PI/3)*global.poly_size*12,sin(j*PI/3)*global.poly_size*12)*2/sqrt(3)
#	draw_polyline(coords1,col,wid)
#	for j in range(6):
#		draw_line(coords[j],coords1[j],col,wid)
		
func make_col(cols):
	modulate = cols
