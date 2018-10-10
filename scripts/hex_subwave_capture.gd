extends Polygon2D

var coll_coords = global.full_hex((global.poly_size*3*2-global.side_offset*4)/sqrt(3),1)
var points_col = global.hex_color(6)
var neg

func _ready():
	position = $"../hex_progress".position
	color = points_col

func collected_points(angle):
	if angle <= 0:
		neg = 1
		angle *= -1
	else:
		neg = 0
	if angle > 0.01:
		show()
		polygon = global.pie_hex(coll_coords,angle)
		if !neg:
			#$"../percentage".set_prc(angle)
			$"../hex_progress".play_note1(angle)
	else:
		hide()