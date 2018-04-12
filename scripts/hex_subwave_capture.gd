extends Polygon2D

var coll_coords = global.full_hex((global.poly_size*3*2-global.side_offset*4)/sqrt(3),1)
var points_col = global.hex_color(6)

func _ready():
	position = $"../hex_progress".position
	color = points_col

func collected_points(angle):
	polygon = global.pie_hex(coll_coords,angle)
	#update()