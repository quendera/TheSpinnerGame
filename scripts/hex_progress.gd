extends Polygon2D

var coords = global.full_hex((global.poly_size*3*2)/sqrt(3),1)
var pie_coords = PoolVector2Array()

func _ready():
	color = global.hex_color(6)
	position = $"../hex_xed".position
	pie_coords.append(Vector2(0,0))
	pie_coords.append(coords[3])
	
func set_shape(val):
	polygon = global.pie_hex(coords,val)

func play_note(pitch,note):
	$"../sine".pitch_scale = pow(2,(pitch/36.0/$"../Spawner".ball_per_sw + note)*2)
	$"../sine".play()
	
func play_note1(pitch):
	$"../sine".pitch_scale = pow(2,(pitch)*2)
	$"../sine".play()