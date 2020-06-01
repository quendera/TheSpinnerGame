extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	polygon = global.full_hex(global.poly_size)
	color = global.hex_color(6)#Color(1,1,1)*.7
