extends Polygon2D

var coords = global.full_hex((global.poly_size*3*2)/sqrt(3),1)
var pie_coords = PoolVector2Array()

func _ready():
	color = global.hex_color(6,1)
	#polygon = global.full_hex((global.poly_size*3*2)/sqrt(3))
	#antialiased = true
	position = $"../hex_xed".position#Vector2(coords[0].x+global.h*global.padding/2+global.side_offset,global.centre.y)
	pie_coords.append(Vector2(0,0))
	pie_coords.append(coords[3])
	
func set_shape(val):
	val = float($"../progress_tween".scale_count - 1 + val)/global.sw_count
	polygon = global.pie_hex(coords,val)
#	if val == 1:
#		polygon = coords
#	elif val > 0:
#		val = val*3
#		if pie_coords.size()/2 <= ceil(val-.001):
#			pie_coords.insert(1,Vector2(0,0))
#			pie_coords.insert(pie_coords.size(),Vector2(0,0))
#			pie_coords[2] = coords[3+floor(val)]
#			pie_coords[-2] = Vector2(pie_coords[2].x,-pie_coords[2].y)
#		pie_coords[1] = coords[fmod(3+ceil(val),6)]*fmod(val,1) + coords[3+floor(val)]*(1-fmod(val,1))
#		pie_coords[-1] = Vector2(pie_coords[1].x,-pie_coords[1].y)
#		polygon = pie_coords
