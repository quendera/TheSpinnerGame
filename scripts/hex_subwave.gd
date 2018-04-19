extends Polygon2D

var total_coords = global.full_hex((global.poly_size*3*2-global.side_offset*2)/sqrt(3),1)

func _ready():
	position = $"../hex_progress".position
	color = global.hint_color(6)

func total_points(angle):
	if angle > 0.01: #prevents poor polygon formation when it is too small
		show()
		polygon = global.pie_hex(total_coords,angle)
	else:
		hide()