extends Polygon2D

var radius
var rot_int
#var rot_offset
#var buffer = sqrt(float(3)/4)
var col = Color()
#var order = [[pad/2,pad],[pad/2,1-pad],[1-pad/2,1-pad],[1-pad/2,pad]]
var order = [[0,-1],[0,1],[1,1],[1,-1]]
var pad = 0#.1
#var size

func _ready():
	add_to_group("cells")

func create(rad, rot):
	#global_position = Vector2(global.cx,global.cy)
	position =  Vector2(global.cx,global.cy) #Vector2(0,(rad + .5)*global.poly_size)
	rotation = rot*PI/3
	radius = rad
	rot_int = rot
	var coords = PoolVector2Array()
	for i in range(4):
		var offsetY = rad+order[i][0] #- (2*order[i][0]-1)*pad
		var offsetX = (offsetY*order[i][1])/sqrt(3) #- order[i][1]*pad
		coords.push_back(Vector2(offsetX,offsetY)*global.poly_size)
	if rad == 0:
		coords.remove(0)
	set_polygon(coords)
	set_z(-1)
	col.a = .2#col.v = .1
	if rad <= 5:
		col.b = float(rad+1)/6
		col.r = col.b
		col.g = col.b#col.s = 0
	else:
		col.b = 0
		col.r = cos(float(12-rad)/5*PI/2)#col.s = 1
		col.g = sin(float(12-rad)/5*PI/2)#col.h = fposmod(float(-.5-rad)/13,1)
	self.set_color(col)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
