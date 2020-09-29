extends Polygon2D

var coords# = global.full_hex((global.poly_size*3*2)/sqrt(3),1)
#var pie_coords = PoolVector2Array()

func _ready():
	color = global.hex_color(6,1)
	if global.scorebar_mode == 0:
		coords = global.full_hex((global.poly_size*3*2)/sqrt(3),1)
		position = Vector2(coords[0].x+global.h*global.padding/2,global.centre.y)
	else:
		#polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2))
		position = Vector2(0,0)
	#position = $"../hex_xed".position#Vector2(coords[0].x+global.h*global.padding/2+global.side_offset,global.centre.y)
	
func set_shape(val):
	if global.scorebar_mode == 0:
		polygon = global.pie_hex(coords,val)
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch*val))
