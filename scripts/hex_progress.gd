extends Polygon2D

#var coords = PoolVector2Array()#
#var cols = PoolColorArray()

func _ready():
	color = global.hint_color(3)
	polygon = global.full_hex((global.poly_size*3*2+global.side_offset)/sqrt(3))
	position = $"../hex_xed".position
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