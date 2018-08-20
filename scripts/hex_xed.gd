extends Polygon2D

var coords = global.full_hex((global.poly_size*3*2+global.side_offset*2)/sqrt(3),1)
var mask = global.full_hex((global.poly_size*3*2)/sqrt(3))
var pie_coords = PoolVector2Array()
var how_far
var cur_bright

func _ready():
	position = Vector2(coords[0].x+global.h*global.padding/2,global.centre.y)
	pie_coords.insert(0,Vector2(0,0))
	pie_coords.append(coords[3])
	how_far = 0
	cur_bright = 0
	color = Color(cur_bright,cur_bright,cur_bright)
	
func _process(delta):
	cur_bright = cur_bright*(1-delta*5)
	color = Color(cur_bright+.4,cur_bright+.4,cur_bright+.4)
	$"../hex_subwave".color = color
	$"../damage".set("custom_colors/font_color",color)

func set_shape(val):
	polygon = global.pie_hex(coords,val)
	cur_bright = 1
	how_far = min(val,1)