extends Polygon2D

func _ready():
	polygon = global.full_hex((global.poly_size*3*2-global.side_offset*2)/sqrt(3))
	position = $"../hex_xed".position
	color = Color(0,0,0)