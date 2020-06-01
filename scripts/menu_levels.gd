extends Node2D

var rot = 0
var off

func _ready():
	position = global.centre
	add_to_group("menu_levels")
	modulate.a = 0
	
func _draw():
	for i in range(rot+1):
		draw_colored_polygon(global.full_hex(global.side_offset,0,rot*Vector2(sin(i*2*PI/(rot+1)),cos(i*2*PI/(rot+1)))*global.side_offset),global.hex_color(6))


func _process(_delta):
	if global.is_unlocked(rot) and modulate.a > 0:
		rotation = OS.get_ticks_msec()/1000.0*PI/2

func set_bright(val):
	if global.is_unlocked(rot):
		modulate.a = val
	else:
		modulate.a = min(val,.1)

func set_rad(val):
	scale = Vector2(val,val)
	position = global.centre + off*val
	if global.is_unlocked(rot):
		modulate.a = val
	else:
		modulate.a = min(val,.1)
	
func create(ang):
	rot = ang
	off = Vector2(-sin(rot*PI/3.0),cos(rot*PI/3.0))*(global.poly_size*4 + global.side_offset/2)
