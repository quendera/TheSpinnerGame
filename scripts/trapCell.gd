extends Polygon2D

var radius
var rot_int
var col = Color()
var order = [[0,-1],[0,1],[1,1],[1,-1]]

func _ready():
	pass
	#add_to_group("cells")

func create(rad, rot):
	position =  global.centre
	rotation = rot*PI/3
	radius = rad
	rot_int = rot
	var coords = PoolVector2Array()
	for i in range(4):
		var offsetY = rad+order[i][0] 
		var offsetX = (offsetY*order[i][1])/sqrt(3)
		coords.push_back(Vector2(offsetX,offsetY)*global.poly_size)
	if rad == 0:
		coords.remove(0)
	set_polygon(coords)
	set_z(-1)
	col = global.which_color(rad+1)
	col.a = .2
	self.set_color(col)
