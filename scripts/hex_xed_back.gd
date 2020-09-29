extends Polygon2D

func _ready():
	if global.scorebar_mode == 1:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch))
		position = Vector2(global.scorebar_anchor+global.poly_size*2,global.h/2)
		color = global.hint_color(0)
	else:
		hide()
