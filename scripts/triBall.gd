extends Polygon2D

var idx
var cur_rot = 0
var cur_rad = 0
var age = 0
var curr_wv
var moving = 1
var dying = 1
var data_line = {"ba_time":0, "ba_position":0, "ba_ID":0, "ba_age":0} #, "ba_score":0
var coords = PoolVector2Array()
var y_range
var order = [[0,-1],[0,1],[1,1],[1,-1]]
var col = Color()
var death_flag = 0
var moveDirs = [0,0]
var cur_rads = [0,0]
var orders = [-1,1]

func _ready():
	add_to_group("balls")

func _process(delta):
#	var moveDir = age-cur_rad
	if death_flag == -1:
		moveDirs[0] = age-cur_rads[0]
	else:
		moveDirs[0] = min(6,age-1)-cur_rads[0]
	moveDirs[1] = age-cur_rads[1]
	cur_rads[0] += moveDirs[0]*delta/global.move_time
	cur_rads[1] += moveDirs[1]*delta/global.move_time
	if cur_rads[0] < 0 or cur_rads[0] > 11.99:
		kill()
	if abs(moveDirs[1]) < .01 and moving:
		moving = 0
		global.data["ba_ID_mv"].push_back(idx)
		global.data["ba_time_mv"].push_back(global.dt)
#	elif moving:
#	cur_rad += moveDir*delta/global.move_time
	var offsetY
	var offsetX
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
		age += 1
		moving = 1
	if age > 12:#curr_wv*2:
		log_data()
		death_flag = -1 #
		#kill()

func kill():
	#log_data()
	self.queue_free()
	#print(get_tree().get_nodes_in_group("balls").size())
	#if  get_tree().get_nodes_in_group("balls").size() == 1:
	#	$score_poly.report(global.score) 
	
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
		#global.score += max(0,age -6)
		global.sw_score += age - 6
		log_data()
		age = 0
		death_flag = 1 #
		#kill()
