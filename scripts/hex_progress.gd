extends Polygon2D

var coords
#var pie_coords

func _ready():
	color = global.hex_color(6)
	$smiley.modulate = color*1.5
	if global.scorebar_mode == 0:
		coords = global.full_hex((global.poly_size*3*2)/sqrt(3),1)
		position = Vector2(coords[0].x+global.h*global.padding/2,global.centre.y)#$"../hex_xed".position
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2))
		position = Vector2(0,0)
		
	
func set_shape(val):
	if global.scorebar_mode == 0:
		polygon = global.pie_hex(coords,val)
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch*val))

func play_note(pitch,note):
	$"../../sine".pitch_scale = pow(2,(pitch/36.0/$"../../Spawner".ball_per_sw + note)*2)
	$"../../sine".play()
	
func play_note1(pitch):
	$"../../sine".pitch_scale = pow(2,(pitch)*2)
	$"../../sine".play()
