extends Polygon2D

func _ready():
	polygon = global.full_hex((global.poly_size*3*2)/sqrt(3))
	color = Color(0,0,0)
