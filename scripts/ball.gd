extends Node2D

var idx
var cur_rot = 0
var cur_rad = 0
var age = 0
var move_time = .05

#DATA
var data = {"time":0, "target_id":0, "target_tx":0, "steps" : 1, "slider_pos" : 0}
var data_dict = {"time":[], "target_id":[], "target_tx":[], "steps":[], "slider_pos":[]}

func _ready():
	position = global.centre
	self.set_scale(Vector2(0,0))
	add_to_group("balls")
	
func _process(delta):
	var moveDir = age-cur_rad
	cur_rad += moveDir*delta/move_time
	position = Vector2(global.cx-cur_rad/12*sin(cur_rot*PI/3)*320,global.cy+cur_rad/12*cos(cur_rot*PI/3)*320)
	scale = Vector2(1,1)*cur_rad/12*1.25

func create(rot, subwave, wave, ball_id):
	cur_rot = int(rot)
	idx = ball_id
	
func step():
	age += 1
	if age > 12:
		kill()

#func collect():
#	log_data()

func kill():
	log_data()
	self.queue_free()
	
func log_data():
	data["time"] = OS.get_unix_time()
	data["target_id"] = idx
	data["target_vtx"] = cur_rot
	data["steps"] = age
	data["slider_pos"] = 12

func save_data():
	var file = File.new()
	file.open("user://data" + str(OS.get_unix_time())+".json", file.WRITE)
	file.store_line(to_json(data))
	file.close()
	
func get_collected(angle):
	if angle == cur_rot and age > 6:
		global.score += age - 6
		kill()