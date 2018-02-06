extends AnimationPlayer

var idx
var cur_rot = 0
var age = 0
var data_line = {"ba_time":0, "ba_position":0, "ba_ID":0, "ba_age":0} #, "ba_score":0
#var col = Color()
var death_flag = 0

func _ready():
	add_to_group("balls")

func _process(delta):
	if death_flag != 0 and .is_playing() == false:
		kill()

func create(rot, subwave, ball_id):
	cur_rot = int(rot)
	idx = ball_id
	for i in range(13):
		var animation = Animation.new()
		animation.length = global.move_time_new#.set_length(1)
		animation.add_track(Animation.TYPE_VALUE)
		animation.add_track(Animation.TYPE_VALUE)
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(0,"../neon_target:frame")
		animation.track_set_path(1,"../neon_target:animation")
		animation.track_set_path(2,"../neon_target:rotation")
		animation.track_insert_key(0, 0, 0)
		animation.track_insert_key(0,animation.length,$neon_target.frames.get_frame_count(String(i)))
		animation.track_insert_key(1,0,String(i))
		animation.track_insert_key(2,0,PI+float(rot)*PI/3)
		.add_animation(String(i), animation)
	
func step():
	.queue(String(age))
	if death_flag == 0:
		age += 1
	if age > 12:
		log_data()
		death_flag = -1 

func kill():
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
	if angle == cur_rot and age > 6 and death_flag == 0:
		global.sw_score += age - 6
		log_data()
		death_flag = 1