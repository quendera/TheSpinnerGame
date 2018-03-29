extends Polygon2D

var coords = global.full_hex((global.poly_size*3*2)/sqrt(3))
var pie_coords = PoolVector2Array()

func _ready():
	color = global.hex_color(6)
	#polygon = global.full_hex((global.poly_size*3*2)/sqrt(3))
	#antialiased = true
	position = Vector2(coords[0].x+global.h*global.padding/2+global.side_offset,global.centre.y)
	pie_coords.append(Vector2(0,0))
	pie_coords.append(coords[3])
	
func set_shape(val):
	if val == 1:
		polygon = coords
	elif val > 0:
		val = val*3
		if pie_coords.size()/2 <= ceil(val-.001):
			pie_coords.insert(1,Vector2(0,0))
			pie_coords.insert(pie_coords.size(),Vector2(0,0))
			pie_coords[2] = coords[3+floor(val)]
			pie_coords[-2] = Vector2(pie_coords[2].x,-pie_coords[2].y)
		pie_coords[1] = coords[fmod(3+ceil(val),6)]*fmod(val,1) + coords[3+floor(val)]*(1-fmod(val,1))
		pie_coords[-1] = Vector2(pie_coords[1].x,-pie_coords[1].y)
		polygon = pie_coords
#
#func _draw():
#	coords = polygon
#	coords.resize(coords.size()+1)
#	coords[-1] = coords[0]
#	draw_polyline(coords,color,2)

#	coords.resize(coords.size()-1)
#	coords.insert(0,Vector2(0,0))
#	#coords[-1].y = -.01
#	#coords.resize(coords.size()+1)
#	cols.resize(coords.size())
#	for i in range(1,cols.size()):
#		cols[i] = global.hex_color(6)
#	#polygon = coords
#	draw_polygon(coords,cols)