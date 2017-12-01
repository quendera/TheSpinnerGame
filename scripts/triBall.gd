extends Polygon2D

var idx
var cur_rot = 0
var age = 0
var curr_wv
var moving = 1
var data_line = {"ba_time":0, "ba_position":0, "ba_ID":0, "ba_age":0} #, "ba_score":0
var coords = PoolVector2Array()
var col = Color()
var death_flag = 0
var moveDirs = [0,0]
var cur_rads = [0,0]
var orders = [-1,1]
var move_start
var offsetY
var offsetX

func _ready():
	move_start = global.dt
	add_to_group("balls")

func _process(delta):
	if global.dt <= move_start+global.move_time_new:
		var prog = sin((global.dt-move_start)/global.move_time_new*PI/2)
		if death_flag == 1:
			cur_rads[1] = age*(1-prog)
			cur_rads[0] = 6*(1-prog)
		else:
			cur_rads[1] = age - 1 + prog
			if death_flag == -1:
				cur_rads[0] = 6+prog*6
			else:
				cur_rads[0] = min(6,cur_rads[1]-1)
	else:
		if death_flag != 0:
			kill()
		if moving:
			moving = 0
#			global.data["ba_ID_mv"].push_back(idx)
#			global.data["ba_time_mv"].push_back(global.dt)
	if moving:
		for i in range(2):
			for j in range(2):
				offsetY = max(.01,cur_rads[i])
				offsetX = (offsetY*orders[fmod(i+j,2)])/sqrt(3)
				coords[2*i+j] = Vector2(offsetX,offsetY)*global.poly_size
		if death_flag == 0:
			col = global.which_color(cur_rads[1])
		if coords[1][1] < coords[2][1]:
			set_color(col)
			set_polygon(coords)

func create(rot, subwave, wave, ball_id):
	position = global.centre
	curr_wv = wave
	cur_rot = int(rot)
	idx = ball_id
	coords.resize(4)
	rotation = float(rot)/3*PI
	
func step():
	if death_flag == 0:
		move_start = global.dt
		age += 1
		moving = 1
	if age > 12:
		log_data()
		death_flag = -1 #
		#kill()

func kill():
	#log_data()
	self.queue_free()
	
func log_data():
	data_line["ba_time"] = global.dt
	data_line["ba_ID"] = idx
	data_line["ba_position"] = cur_rot #redundant
	data_line["ba_age"] = age
	#data_line["ba_score"] = global.score
	for key in data_line.keys():
		global.data[key].push_back(data_line[key])

func get_collected(angle):
	if angle == cur_rot and age > 6:
		moving = 1
		move_start = global.dt
		global.sw_score += age - 6
		log_data()
		death_flag = 1
