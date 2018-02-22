extends Polygon2D


var hex_outline = PoolVector2Array()

func _ready():
	color = Color(1,1,1)/2#global.which_color(12)
	position = Vector2(global.w/5,global.h*.25)	
	hex_outline = global.full_hex(global.progress_rad,1)