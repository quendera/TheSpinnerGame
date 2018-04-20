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
		get_tree().call_group("hint_balls", "dimmer",idx,1-progress)
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
	if age > 0: # and !is_collected
		if age > 6 and age < 7:
			if !is_collected:
				$"/root/game/miss".play() #was miss
				is_collected = 1
				$"/root/game/Spawner".balls_left -= 1
			for i in range(3):
				var ang = float(i+(age-6))/3*PI*2
				#coords[i] = Vector2(sin(ang)*(age-6+1.0/6)*6,-cos(ang)*(age-6+1.0/6)*6+1)/sqrt(3)*global.poly_size*2*6
				#cols[i].a = 7-age
				coords[i] = Vector2(sin(ang)*(7-age),-cos(ang)*(7-age)+1)/sqrt(3)*global.poly_size*6
				cols[i] = global.hex_color((7-age-int(i == 0))*6)*(7-age) + global.hint_color((7-age-int(i == 0))*6)*(age-6)
			get_tree().call_group("hint_balls", "dimmer",idx,7-age)
		else:
			for i in range(2):
				coords[i+1] = Vector2((age*orders[i])/sqrt(3),age)*global.poly_size
				cols[i+1] = global.hex_color(age)
				#cols[i+1].a = .5
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
		queue_free()
		if $"/root/game/Spawner".balls_left == 0:
			$"/root/game/action_tween".wave_age = -6
			$"/root/game/Spawner".balls_left = $"/root/game/Spawner".ball_per_sw
			$"/root/game/progress_tween".finish_hints_discrete()#Spawner".mySpawn()

func get_collected(angle):
	if angle == cur_rot and age > 0 and age <= 6 and is_collected == 0:
		$"/root/game/Spawner".balls_left -= 1
		is_collected = 1
		#get_node("/root/game/collect"+String(age)).play()
		#$String(["/root/game/collect",age]).play()
		var sw = $"/root/game/Spawner".sw
		#var point_start = $"/root/game/Spawner".accum_points[-1] - $"/root/game/Spawner".accum_points[sw-1] - global.sw_score
		this_point = pow(age,2)
		#global.delay.set_feedback_level_db(this_point/36.0-1.05)
		#$"/root/game/harp".play()
		#$"/root/game/progress_tween".interpolate_method($"/root/game/hex_progress","set_pitch",0,this_point-1,global.harp_pluck_len*this_point,$"/root/game/action_tween".transition,$"/root/game/action_tween".ease_direction)
		for i in range(this_point):#age):#
			$"/root/game/progress_tween".interpolate_callback($"/root/game/hex_progress",i*global.harp_pluck_len,"play_note",i)#pow(i,2))
		global.score += this_point
		this_point = float(this_point)/36.0/$"/root/game/Spawner".ball_per_sw#$"/root/game/Spawner".curr_wv_points
		$"/root/game/progress_tween".slide_hints(this_point)
		#global.sw_score += this_point
#		$"/root/game/score_poly".sw_outline = global.spiral_peel(1 - float($"/root/game/Spawner".accum_points[sw-1] + global.sw_score)/$"/root/game/Spawner".accum_points[-1])
#		$"/root/game/score_poly".update()