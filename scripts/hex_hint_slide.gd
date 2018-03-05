extends Polygon2D

var idx
var cur_rot
var next_rot
var coords = PoolVector2Array()
var cols = PoolColorArray()
var eps = .001
var cur_rads
var orders = [-1,1]

func _ready():
	add_to_group("hint_slide")
	offset = Vector2(0,global.side_offset)

func create(rot,ball_id): 
	position = global.centre
	cur_rot = int(rot)
	idx = ball_id
	coords.resize(4)
	cols.resize(4)
	rotation = float(cur_rot)/3*PI
	var age = 6-idx
	cur_rads = [max(age-1,eps),min(6,age)+eps]
	for i in range(2):
		for j in range(2):
			coords[2*i+j] = Vector2((cur_rads[i]*orders[fmod(i+j,2)])/sqrt(3),cur_rads[i])*global.poly_size*2
			cols[2*i+j] = global.hint_color(cur_rads[i])
	polygon = coords
	vertex_colors = cols
	
func set_next_pos(loc,ind):
	if ind == idx:
		next_rot = loc
		if abs(cur_rot - next_rot) > 3:
			if next_rot > cur_rot:
				next_rot -= 6
			else:
				next_rot += 6

func set_shape(weight):
	rotation = ((1-weight)*cur_rot + weight*next_rot)*PI/3
	return rotation

func set_shape_finish():
	cur_rads = set_shape(1)
	cur_rot = next_rot