extends Polygon2D

var idx
var cur_rot
var age
var coords = PoolVector2Array()
var cols = PoolColorArray()
var orders = [-1,1]
var is_collected = 0
var is_logging = 0
var this_point
var ang

func _ready():
	add_to_group("hex_balls")
	offset = Vector2(0,global.side_offset/2)
	position = global.centre
	coords.resize(3)
	cols.resize(3)
	coords[0] = Vector2(0,0)
	cols[0] = global.hex_color(0)

func create(rot, ball_id): 
	cur_rot = int(rot)
	idx = ball_id
	rotation = float(rot)/3*PI
	
func run_collection(progress):
	if is_collected == 1:
		#get_tree().call_group("hint_balls", "dimmer",idx,1-progress)
		get_tree().call_group("hex_slider","push_target",progress,age,cur_rot)
		if progress == 1:
			log_data()
		else:
			progress = max(1-progress*2,.01)
			for i in range(2):
				coords[i+1] = progress*Vector2((age*orders[i])/sqrt(3),age)*global.poly_size
				cols[i+1] = global.hex_color(age*progress)
			polygon = coords
			vertex_colors = cols
	
func set_shape(wave_age):
	age = wave_age-idx
	if age > 0: 
		if age > 6 and age < 7:
			if !is_collected:
				$"../../miss".play() #was miss
				is_collected = 1
				$"..".balls_left -= 1
			for i in range(3):
				ang = float(i+(age-6))/3*PI*2
				coords[i] = Vector2(sin(ang)*(7-age),-cos(ang)*(7-age)+1)/sqrt(3)*global.poly_size*6
				cols[i] = global.hex_color((7-age-int(i == 0))*6)*(7-age) + global.hint_color((7-age-int(i == 0))*6)*(age-6)

		else:
			for i in range(2):
				coords[i+1] = Vector2((age*orders[i])/sqrt(3),age)*global.poly_size
				cols[i+1] = global.hex_color(age)
		polygon = coords
		vertex_colors = cols
	if age >= 7:
		log_data()
	
func log_data():
	if !is_logging:
		is_logging = 1
		global.data["ba_time"].push_back(OS.get_ticks_msec())#global.dt
		global.data["ba_ID"].push_back(idx)
		global.data["ba_position"].push_back(cur_rot) #redundant
		global.data["ba_age"].push_back(age)
		get_tree().call_group("hint_balls", "eliminate",idx)
		if $"..".balls_left == 0:
			$"../../action_tween".wave_age = -6
			$"..".balls_left = $"..".ball_per_sw
			$"../../progress_tween".finish_hints_discrete()
		queue_free()

func get_collected(angle):
	if angle == cur_rot and age > 0 and age <= 6 and is_collected == 0:
		$"..".balls_left -= 1
		is_collected = 1
		#var sw = $"..".sw
		#this_point = pow(age,2)
		#$"../../progress_tween".interpolate_method($"../../hex_progress","play_note1",$"../../progress_tween".sw_score,$"../../progress_tween".sw_score+(this_point-1)/36.0/$"..".ball_per_sw,this_point*global.harp_pluck_len,Tween.TRANS_LINEAR,Tween.EASE_IN,0)#,$"../../progress_tween".sw_score)
		#for i in range(this_point):
		#	$"../../progress_tween".interpolate_callback($"../../hex_progress",i*global.harp_pluck_len,"play_note",i,$"../../progress_tween".sw_score)#pow(i,2))
		#global.score += this_point
		this_point = float(pow(age,2))/36.0/$"..".ball_per_sw
		$"../../progress_tween".slide_hints(this_point)
		if age > 3 and $"../..".has_node("hex_teacher"):
			$"../../hex_teacher".queue_free()
