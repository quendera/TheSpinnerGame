extends Polygon2D

func _ready():
	polygon = global.full_hex(global.poly_size*.66)
	color = global.hex_color(1,true)
