extends Polygon2D

var idx
var cur_rot
var age
var coords = PoolVector2Array()
var cols = PoolColorArray()
var eps = .001
var cur_rads
var orders = [-1,1]

func _ready():
	add_to_group("hint_balls")
	offset = Vector2(0,global.side_offset/2)
	position = global.centre
	coords.resize(4)
	cols.resize(4)

func create(rot, ball_id): 
	cur_rot = int(rot)
	idx = ball_id
	rotation = float(rot)/3*PI
	
func set_shape(wave_age):
	age = 6-idx+wave_age
	if age > 0 and wave_age <= 0:
		cur_rads = [max(age-1,eps),min(6,age)+eps]
		for i in range(2):
			for j in range(2):
				coords[2*i+j] = Vector2((cur_rads[i]*orders[fmod(i+j,2)])/sqrt(3),cur_rads[i])*global.poly_size
				cols[2*i+j] = global.hint_color(cur_rads[i])
		polygon = coords
		vertex_colors = cols

func dimmer(id,val):
	if idx == id:
		modulate = Color(1,1,1,val)

func eliminate(id):
	if idx == id:
		queue_free()
