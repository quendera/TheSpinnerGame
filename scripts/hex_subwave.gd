extends Polygon2D

var total_coords = global.full_hex((global.poly_size*3*2-global.side_offset*2)/sqrt(3),1)
var coll_coords = global.full_hex((global.poly_size*3*2-global.side_offset*4)/sqrt(3),1)
var frac_poly = PoolVector2Array()
var points_col = global.hex_color(6)
var back_col = global.hint_color(6)
var targets = PoolVector2Array()

func _ready():
	position = $"../hex_progress".position
#	polygon =  global.full_hex((global.poly_size*3*2-global.side_offset*2)/sqrt(3))
	color = back_col #global.hint_color(6) #
#	scale = Vector2(1,1)*0

func _draw():
	if frac_poly.size() > 2:
		draw_colored_polygon(frac_poly,points_col)
		#draw_line(Vector2(0,0),frac_poly[-1],Color(.5,.5,.5),5)
		#targets[-1] = frac_poly[-1]
		#for i in range(targets.size()):
		#	draw_line(Vector2(0,0),targets[i],back_col,5)
		

func pie_hex(full,angle):
	angle *= 6
	var coords = PoolVector2Array(full)
	if angle >= 6:
		coords.resize(6)
	elif angle > 0:
		coords.insert(0,Vector2(0,0))
		coords.resize(ceil(angle)+2)
		angle = fmod(angle,1)
		if angle > 0:
			coords[coords.size()-1] = full[coords.size()-2]*angle+full[coords.size()-3]*(1-angle)
	else:
		coords.resize(0)
	return coords
	#polygon = coords
	
func total_points(angle):
	if angle > 0:
		show()
		polygon = pie_hex(total_coords,angle)
	else:
		hide()

func add_line():
	targets.resize(targets.size()+1)
	
func collected_points(angle):
	frac_poly = pie_hex(coll_coords,angle)
	update()