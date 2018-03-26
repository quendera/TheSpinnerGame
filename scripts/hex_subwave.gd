extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	position = $"../hex_progress".position
	polygon =  global.full_hex((global.poly_size*3*2-global.side_offset)/sqrt(3))
	color = global.hint_color(6)#hex_color(6,0,.7)
	scale = Vector2(1,1)*0
