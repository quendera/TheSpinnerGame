extends Polygon2D

var coords = global.full_hex((global.poly_size*3*2+global.side_offset*2)/sqrt(3))
var pie_coords = PoolVector2Array()

func _ready():
	position = Vector2(coords[0].x+global.h*global.padding/2+global.side_offset,global.centre.y)
	color = global.hint_color(6)
	pie_coords.insert(0,Vector2(0,0))
	pie_coords.append(coords[3])

func _draw():
	draw_colored_polygon(global.full_hex((global.poly_size*3*2+global.side_offset)/sqrt(3)),Color(0,0,0))
	#draw_polyline(global.full_hex((global.poly_size*3*2+global.side_offset)/sqrt(3),1),global.hint_color(6),2)

func set_shape(val):
	if val == 1:
		polygon = coords
	elif val > 0:
		val = val*3
		if pie_coords.size()/2 <= ceil(val):
			pie_coords.insert(1,Vector2(0,0))
			pie_coords.insert(pie_coords.size(),Vector2(0,0))
			pie_coords[2] = coords[3+floor(val)]
			pie_coords[-2] = Vector2(pie_coords[2].x,-pie_coords[2].y)
		pie_coords[1] = coords[fmod(3+ceil(val),6)]*fmod(val,1) + coords[3+floor(val)]*(1-fmod(val,1))
		pie_coords[-1] = Vector2(pie_coords[1].x,-pie_coords[1].y)
		polygon = pie_coords