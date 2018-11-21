extends Polygon2D

var my_scale = 1
var my_offset = Vector2(0,0)
var num_good = 0

func _ready():
	#position = global.centre
	color = Color(1,1,1)#global.hex_color(6,true)
	#offset = Vector2(0,global.poly_size*4 + global.side_offset/2)
	polygon = global.full_hex(global.poly_size*2/sqrt(3))
	if $"../Spawner".ball_per_sw > 1:
		queue_free()

func _process(delta):
	if my_scale < 0:
		my_scale += 1
		$"../sine".pitch_scale = 1
		$"../sine".play()
	else:
		my_scale = my_scale-delta/global.move_time_new/2
	if $"../action_tween".wave_age >= 4:
		if polygon.size() == 6:
			scale = Vector2(1,1)
			polygon = global.full_tri(global.poly_size*2/sqrt(3))
		position = global.centre + my_offset*my_scale
		#polygon[0] = Vector2(0,-1)*global.poly_size*2/sqrt(3)*(2-2*my_scale)
	else:
		if polygon.size() == 3:
			polygon = global.full_hex(global.poly_size*2/sqrt(3))
			position = global.centre + my_offset
	if $"../action_tween".wave_age < 0:
		my_scale = 0
	scale = Vector2(1,1)*my_scale

func set_pos(rot):
	my_offset = (global.poly_size*4 + global.side_offset/2)*Vector2(-sin(rot*PI/3.0),cos(rot*PI/3.0))
	position = global.centre + my_offset
	rotation = rot*PI/3
