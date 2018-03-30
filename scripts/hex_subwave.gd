extends Polygon2D

func _ready():
	position = $"../hex_progress".position
	polygon =  global.full_hex((global.poly_size*3*2-global.side_offset*2)/sqrt(3))
	color = global.hint_color(6) #
	scale = Vector2(1,1)*0