extends Polygon2D

var coords
var mask
#var pie_coords = PoolVector2Array()
#var how_far
var cur_bright

func _ready():
	#how_far = 0
	cur_bright = 0
	color = Color(cur_bright,cur_bright,cur_bright)
	color = global.hex_color(6)
	if global.scorebar_mode == 0:
		coords = global.full_hex((global.poly_size*3*2+global.side_offset*2)/sqrt(3),1)
		position = Vector2(coords[0].x+global.h*global.padding/2,global.centre.y)
		mask = global.full_hex((global.poly_size*3*2)/sqrt(3))
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2))
		position = Vector2(0,0)#(global.scorebar_anchor+global.poly_size*2,global.h/2)
	
func _process(delta):
	cur_bright = cur_bright*(1-delta*5)
	color = Color(cur_bright+.4,cur_bright+.4,cur_bright+.4)
	$"../../hex_subwave".color = color
	$frowney.modulate = color*2
	if global.scorebar_mode == 0:
		$"../damage".set("custom_colors/font_color",color)
	else:
		$"../hex_xed_text".set("custom_colors/font_color",color)

func set_shape(val):
#	polygon = global.pie_hex(coords,val)
	cur_bright = 1
	#how_far = min(val,1)
	if global.scorebar_mode == 0:
		polygon = global.pie_hex(coords,val)
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch*min(1,val)))
