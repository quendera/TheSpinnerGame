extends Polygon2D

var total_coords
#var points_col = global.hex_color(6)
#var neg

func _ready():
	color = global.hex_color(6)#points_col
	if global.scorebar_mode == 0:
		position = $"../hex_progress".position
		total_coords = global.full_hex((global.poly_size*3*2-global.side_offset*4)/sqrt(3),1)
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2))
		position = Vector2(global.scorebar_anchor+global.poly_size*4,global.h/2)

func collected_points(angle):
#	if angle <= 0:
#		neg = 1
#		angle *= -1
#	else:
#		neg = 0
#	if angle > 0.01:
#		show()
#		polygon = global.pie_hex(coll_coords,angle)
#		#if !neg:
#		#	#$"../percentage".set_prc(angle)
#	#		$"../hex_progress".play_note1(angle)
#	else:
#		hide()
	if global.scorebar_mode == 0:
		if angle > 0.01: #prevents poor polygon formation when it is too small
			show()
			polygon = global.pie_hex(total_coords,angle)
		else:
			hide()
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch*angle))
