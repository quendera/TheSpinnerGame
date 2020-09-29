extends Polygon2D

func _ready():
	if global.scorebar_mode == 0:
		polygon = global.full_hex((global.poly_size*3*2)/sqrt(3))
		color = Color(0,0,0)
