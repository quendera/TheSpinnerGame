extends Polygon2D

var radius = global.poly_size*6*2/sqrt(3)*.7
var hex_outline = PoolVector2Array()

func _ready():
	color = Color(1,1,1)/2#global.which_color(12)
	position = Vector2(global.w/5,global.h*.25)	
	hex_outline = global.full_hex(radius,1)