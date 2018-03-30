extends Polygon2D

var hexcoords = global.full_hex(global.side_offset/sqrt(3)/2,0)
var coords = PoolVector2Array()
var cols = PoolColorArray()
var stretch = [0,0]
var how_long

func _ready():
	position = global.centre
	coords.resize(6)
	cols.resize(6)
	how_long = global.centre.x - $"../hex_xed".position.x

func set_shape(progress,points,col = 0):
	stretch = [max(0,min(1,progress*2-points/36.0)),min(1,progress*2)]
	if stretch[0] == stretch[1]:
		hide()
	else:
		for i in range(6):
			coords[i] = hexcoords[i] - Vector2(stretch[int(!(i < 2 or i == 5))]*how_long,0)
			cols[i] = global.hex_color(stretch[int(!(i < 2 or i == 5))]*6,col)
		polygon = coords
		vertex_colors = cols
		show()

func new_wave(progress):
	set_shape(progress,36,1)