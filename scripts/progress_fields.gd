extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pad = global.padding*global.h/2
var coords = PoolVector2Array()
#var curr_coords = PoolVector2Array()
var scale_this = 0
var cols = PoolColorArray()

func _ready():
	position = Vector2($"../progress_full".coords[3].x+pad*2+global.side_offset,global.h-pad-global.side_offset/2)
	coords.resize(4)
	coords[0] = Vector2(0,0)
	coords[1] = Vector2(0,global.centre.y-position.y)#global.centre.x-global.poly_size*(6+global.offset_poly_ratio)/sqrt(3)-4*pad,0)
	coords[2] = Vector2(-coords[1].y/sqrt(3),0) + coords[0]
	coords[3] = coords[0]
	#curr_coords = coords
	cols.resize(4)
	cols[0] = global.hint_color(6)
	cols[1] = global.hint_color(6)
	cols[2] = global.hex_color(6)
	cols[3] = cols[2]
	modulate = Color(1,1,1,.5)

func _draw():
	for i in range(3):
#		curr_coords[i] = coords[i]*scale_this
		draw_polyline_colors([coords[i],coords[i+1]],[cols[i],cols[i+1]],2) #curr_coords
		
func my_update(sc):
	scale_this = sc
	update()
	