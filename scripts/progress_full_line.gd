extends Node2D

var coords = PoolVector2Array()
var cols = PoolColorArray()

func _ready():
	position = $"../progress_full".position
	#coords.append($"../progress_full".coords[3])
	#cols.append(global.hex_color(6))

func _draw():
	if coords.size() > 1:
		#draw_polyline_colors(coords,cols,5)
		draw_polyline(coords,Color(0,0,0),5)#global.hex_color(6,1)
	
func set_shape():
	var dist_to_fail = (1-($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/float((1-$"../progress_full".pass_thresh)*$"../Spawner".accum_points[-1]))
	coords.append(Vector2(($"../progress_full".coords[2].x)*dist_to_fail,$"../progress_full".coords[2].y*$"../Spawner".accum_points[$"../Spawner".sw]/$"../Spawner".accum_points[-1]))
	cols.append(global.hex_color(6)*dist_to_fail + global.hint_color(6)*(1-dist_to_fail))
	update()

