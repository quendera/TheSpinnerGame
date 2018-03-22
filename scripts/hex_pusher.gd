extends Polygon2D

var dist = 0
var coords = PoolVector2Array()
var cols = PoolColorArray()

func _ready():
	coords.resize(4)
	cols.resize(4)
	offset = Vector2(0,global.side_offset/2)
	position = global.centre
	coords[0] = Vector2(1/sqrt(3),1)*6*global.poly_size
	coords[1] = Vector2(-coords[0].x,coords[0].y)
	cols[0] = global.hex_color(6,1)
	cols[1] = cols[0]

func set_shape(prog,age,rot):
	rotation = rot*PI/3
	prog = max(6-age*(1-abs(prog - .5)*2),.01)
	coords[2] = Vector2(-1/sqrt(3),1)*prog*global.poly_size
	coords[3] = Vector2(-coords[2].x,coords[2].y)
	cols[2] = global.hex_color(prog,1)
	cols[3] = cols[2]
	if prog == 1:
		hide()
	else:
		polygon = coords
		vertex_colors = cols#if !visible:
		show()