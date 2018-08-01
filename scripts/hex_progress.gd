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
#	if val == 1:
#		polygon = coords
#	elif val > 0:
#		val = val*3
#		if pie_coords.size()/2 <= ceil(val-.001):
#			pie_coords.insert(1,Vector2(0,0))
#			pie_coords.insert(pie_coords.size(),Vector2(0,0))
#			pie_coords[2] = coords[3+floor(val)]
#			pie_coords[-2] = Vector2(pie_coords[2].x,-pie_coords[2].y)
#		pie_coords[1] = coords[fmod(3+ceil(val),6)]*fmod(val,1) + coords[3+floor(val)]*(1-fmod(val,1))
#		pie_coords[-1] = Vector2(pie_coords[1].x,-pie_coords[1].y)
#		polygon = pie_coords

func play_note(pitch,note):
	#AudioServer.get_bus_effect(1,0).pitch_scale = pow(2,(pitch/36.0/$"../Spawner".ball_per_sw + note)*2)
	
	#set_pitch(pitch,note)
	$"../sine".pitch_scale = pow(2,(pitch/36.0/$"../Spawner".ball_per_sw + note)*2)
	$"../sine".play()

#func set_pitch(pitch):
#	AudioServer.get_bus_effect(1,0).pitch_scale = pow(2,(pitch/36.0/$"/root/game/Spawner".ball_per_sw + $"/root/game/progress_tween".sw_score)*2)