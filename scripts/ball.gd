extends Node2D

var idx
export var cur_rot = 0
var target_v = Vector2()
var path_v
export var age = 0


#DATA
var data = {"time":0, "target_id":0, "target_tx":0, "steps" : 1, "slider_pos" : 0}
var data_dict = {"time":[], "target_id":[], "target_tx":[], "steps":[], "slider_pos":[]}



func _onready():
	var tr = PoolVector2Array([[1,2],[1,2]])
	
	
func _ready():
	position = global.centre
	self.set_scale(Vector2(0,0))
	add_to_group("balls")

func create(rot, subwave, wave, ball_id):
	cur_rot = int(rot)
	idx = ball_id
	target_v = global.centre - global.vertices[cur_rot]
	path_v = global.centre-target_v
	global_rotation = atan2(path_v.x, path_v.y)
	
func step():
	scale = Vector2(1,1)
	position += path_v/1.5
	#print(scale)
	age += 1
	if age > 12:
		kill()
		

func collect():
	log_data()
	

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
	
	if angle == cur_rot and age > 5:
		global.score += age
		print(global.score)
		kill()
