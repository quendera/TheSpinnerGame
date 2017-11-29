extends Polygon2D

var radius
var rot_int
var rot_offset
var buffer = sqrt(float(3)/4)
var col = Color()
#var size

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	add_to_group("cells")
	
func create(rad, rot):
	radius = rad
	rot_int = floor(rot/max(1,rad))
	rot_offset = fmod(rot,max(1,rad))
	var coords = PoolVector2Array()
	var xc = (cos(rot_int*PI/3)*rot_offset/max(1,rad) + cos((rot_int+1)*PI/3)*(1-rot_offset/max(1,rad)))*global.hex_size*rad
	var yc = (sin(rot_int*PI/3)*rot_offset/max(1,rad) + sin((rot_int+1)*PI/3)*(1-rot_offset/max(1,rad)))*global.hex_size*rad
	for k in range(6):
		var offsetX = sin(k*PI/3)*global.hex_size*buffer/2
		var offsetY = cos(k*PI/3)*global.hex_size*buffer/2
		coords.push_back(Vector2(global.cx+xc+offsetX,global.cy+yc+offsetY))
	self.set_polygon(coords)
	if rot_offset == 0:
		col.a = 0#col.v = 0
	else:
		col.a = .5#col.v = .1
	if rad <= 7:
		col.b = 1
		col.r = 1
		col.g = 1#col.s = 0
	else:
		col.b = 0
		col.r = cos(float(13-rad)/6*PI/2)#col.s = 1
		col.g = sin(float(13-rad)/6*PI/2)#col.h = fposmod(float(-.5-rad)/13,1)
	self.set_color(col)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
