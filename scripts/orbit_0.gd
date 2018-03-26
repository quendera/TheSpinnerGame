extends Polygon2D

var cur_loc # = 0
var freq = 3
var modu

func _ready():
	polygon = global.full_hex(global.side_offset/sqrt(3),0)
	#color = global.hex_color(6)
	#position = $"../hex_xed".position
	#offset = Vector2(0,global.poly_size*3+global.side_offset/4)

func _process(delta):
	cur_loc = fmod(global.dt,3)/3#*($"../Spawner".sw)/$"../Spawner".accum_points.size()
	position = $"../hex_xed".position + Vector2((global.poly_size*3+global.side_offset/4)*2/sqrt(3),0)
	position = global.centre*cur_loc + position*(1-cur_loc)
#	offset = hexGrid[floor(cur_loc)]*(1-fmod(cur_loc,1)) + hexGrid[ceil(cur_loc)]*(fmod(cur_loc,1))
	color = global.hex_color(6,sin((exp(cur_loc*freq)-1)) > 0)#)*(.5-sin(cur_loc*30)/2) + global.hex_color(6,true)*(.5+sin(cur_loc*30)/2)
	color.s = (1-cos((exp(cur_loc*freq)-1)*2)/2)*cur_loc
	if cur_loc*$"../Spawner".accum_points.size() > $"../Spawner".sw-1:
		color.a = .1
	else:
		color.a = 1