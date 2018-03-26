extends Polygon2D
var col
var hexGrid = global.full_hex((global.poly_size*3)*2/sqrt(3),1)
var cur_loc

func _ready():
	polygon = global.full_hex(global.side_offset/sqrt(3),0)
	color = global.hex_color(6,true)
	position = $"../hex_xed".position
	#offset = Vector2(0,global.poly_size*3+global.side_offset/4)

func _process(delta):
	cur_loc = fmod(global.dt,3)
	offset = hexGrid[6-floor(cur_loc)]*(1-fmod(cur_loc,1)) + hexGrid[6-ceil(cur_loc)]*(fmod(cur_loc,1))
	color.s = cur_loc/3
	#color.a = max(0,min(1,1-color.s*$"../Spawner".accum_points.size()/$"../Spawner".sw))
	if color.s*$"../Spawner".accum_points.size() > $"../Spawner".sw-1:
		color.a = .1
	else:
		color.a = 1