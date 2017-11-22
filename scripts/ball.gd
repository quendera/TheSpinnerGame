extends Node2D

var idx
var cur_rot = 0
var cur_rad = -1
var age = 0
var curr_wv
var moving = 1
var data_line = {"ba_time":0, "ba_position":0, "ba_ID":0, "ba_age":0} #, "ba_score":0

func _ready():
	position = global.centre
	self.set_scale(Vector2(0,0))
	add_to_group("balls")
	
func _process(delta):
	var moveDir = age-cur_rad
	if abs(moveDir) < .01 and moving:
		moving = 0
		global.data["ba_ID_mv"].push_back(idx)
		global.data["ba_time_mv"].push_back(global.dt)
#	elif moving:
	cur_rad += moveDir*delta/global.move_time
	position = Vector2(global.cx-cur_rad/curr_wv/2*sin(cur_rot*PI/3)*320,global.cy+cur_rad/curr_wv/2*cos(cur_rot*PI/3)*320)
	scale = Vector2(1,1)*cur_rad/curr_wv/2*1.25

func create(rot, subwave, wave, ball_id):
	curr_wv = wave
	cur_rot = int(rot)
	idx = ball_id
	
func step():
	age += 1
	moving = 1
	if age > curr_wv*2:
		kill()

func kill():
	log_data()
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
	if angle == cur_rot: # and age > curr_wv:
		global.score += max(0,age - curr_wv + 1)
		kill()