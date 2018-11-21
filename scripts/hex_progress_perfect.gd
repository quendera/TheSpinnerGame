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
#	val = float($"../progress_tween".scale_count - 1 + val)/global.sw_count
	polygon = global.pie_hex(coords,val)
