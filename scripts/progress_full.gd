extends Node2D

var pad = global.padding*global.h/2
var coords = PoolVector2Array()
var cols = PoolColorArray()
var pass_thresh = .8

func _ready():
	position = Vector2(pad+global.side_offset/2,global.h-pad-global.side_offset/2)
	coords.resize(4)
	coords[0] = Vector2(0,0)
	coords[1] = Vector2(0,-(global.h-pad*2-global.side_offset))#Vector2(1/sqrt(3),-1)*(global.h-2*pad-global.side_offset)#global.centre.x-global.poly_size*(6+global.offset_poly_ratio)/sqrt(3)-4*pad,0)
	coords[2] = Vector2(-coords[1].y*(1-pass_thresh)/pass_thresh*sqrt(3),0)+coords[1]#coords[1].x*3/4.0,-coords[1].x*sqrt(3)/4)
	coords[3] = Vector2(coords[2].x,0)
	#coords[4] = coords[0]
	cols.resize(4)
	cols[0] = global.hint_color(6)
	cols[1] = global.hint_color(6)
	cols[2] = global.hex_color(6)
	cols[3] = global.hex_color(6)
	#cols[4] = cols[0]
	modulate = Color(1,1,1,.5)

func _draw():
	#for i in range(4):
	#	draw_polyline_colors([coords[i],coords[i+1]],[cols[i],cols[i+1]],2)
	print(coords)
	draw_polygon(coords,cols)
