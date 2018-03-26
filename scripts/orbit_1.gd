extends Polygon2D
var col
var hexGrid = global.full_hex((global.poly_size*3)*2/sqrt(3))
var cur_loc # = 0

func _ready():
	polygon = global.full_hex(global.side_offset/sqrt(3),0)
	color = global.hex_color(6)
	position = $"../hex_xed".position
	#offset = Vector2(0,global.poly_size*3+global.side_offset/4)

func _process(delta):
	cur_loc = fmod(global.dt,3)#*($"../Spawner".sw)/$"../Spawner".accum_points.size()
	offset = hexGrid[floor(cur_loc)]*(1-fmod(cur_loc,1)) + hexGrid[ceil(cur_loc)]*(fmod(cur_loc,1))
	color.s = cur_loc/3
	if color.s*$"../Spawner".accum_points.size() > $"../Spawner".sw-1:
		color.a = .1
	else:
		color.a = 1