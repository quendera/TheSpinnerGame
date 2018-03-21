extends Node2D

var coords = PoolVector2Array()
var prog = -1

func _ready():
	coords.resize(2)
	position = $"/root/game/progress_fields".position
	
func _draw():
	if prog < 0:
		coords[1] = Vector2(0,$"/root/game/progress_fields".coords[1].y*(1+prog))
	else:
		coords[1] = $"/root/game/progress_fields".curr_coords[2]*prog + $"/root/game/progress_fields".curr_coords[1]*(1-prog)
	draw_line(coords[0],coords[1],$"/root/game/progress_fields".cols[2]*max(0,prog) + $"/root/game/progress_fields".cols[1]*(1-max(0,prog)),5)
	
func set_shape(pr):
	#scale = $"/root/game/progress_fields".scale
	prog = pr
	update()
