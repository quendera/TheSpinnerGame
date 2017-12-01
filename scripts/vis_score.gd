extends Node2D

var coords = PoolVector2Array()
var offset = Vector2(global.poly_size,global.poly_size)*3
var centers = PoolVector2Array()

func _ready():
	var gridX
	var gridY
	#set_z(-1)
	centers.resize(global.sw_count)
	coords.resize(7)
	for j in range(7):
		coords[j] = Vector2(cos(j*PI/3)*global.poly_size,sin(j*PI/3)*global.poly_size)*2/sqrt(3)
	for i in range(global.sw_count):
		gridX = fmod(i,global.sw_count/10)
		gridY = i*10/global.sw_count#fmod(i,10)
		gridY = (gridY*2+fmod(gridX,2))*global.poly_size + offset[1]
		gridX = gridX*global.poly_size*sqrt(3) + offset[0]
		centers[i] = Vector2(gridX,gridY)

func _draw():
	var temp_coords = PoolVector2Array()
	temp_coords.resize(7)
	for i in range(global.sw_count):
		for j in range(7):
			temp_coords[j] = centers[i]+coords[j]
		self.draw_polyline_colors(temp_coords,PoolColorArray([Color(1,1,1)/2]),2,1)