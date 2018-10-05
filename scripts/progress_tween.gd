extends Tween

var sw_score
var norm
var frac_fail = 0
var frac_fail_new
#var finish_point_seq_len = 1
var fail_time_ratio = 3#(1-fail_thresh)/fail_thresh
var num_sounds
var start_time
var note_count = 0
var scale_time = global.move_time_new*6
var drone_note = 0
var scale_count = 0
var notes_per_scale = 8
var play_state = Vector3(0,0,0) #completed time for piece, index of notes played
var num_fails = 0

func _ready():
	#playback_process_mode = TWEEN_PROCESS_PHYSICS
	$"../spiccato".volume_db = -5
	$"../spiccatoB".volume_db = 0
	$"../drone".volume_db = -25
	$"../droneB".volume_db = -20
	start()

func reset_hints():
	interpolate_method(self,"reset_sliders",-6,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score = 0
	norm = ($"../Spawner".curr_wv_points/($"../Spawner".ball_per_sw*36.0))
	interpolate_method($"../hex_subwave","total_points",0,norm,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	$"../hex_subwave_capture".color = global.hex_color(6) 
	$"../percentage".set_prc(0)
	start()

func reset_sliders(wave_age):
	get_tree().call_group("hex_slider","set_shape", wave_age)

func finish_hints_discrete():
	num_sounds = ceil(sw_score*36*$"../Spawner".ball_per_sw) #/points_per_click
	start_time = global.move_time_new
	if num_sounds == 0:
		$"../hex_progress".set_shape(float($"../Spawner".sw)/global.sw_count)
	elif round(sw_score*36*$"../Spawner".ball_per_sw) == $"../Spawner".curr_wv_points:
		$"../hex_subwave_capture".color = global.hex_color(6,1) 
		interpolate_method($"../hex_subwave_capture","collected_points",sw_score,0,global.game_measure,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_subwave","total_points",sw_score,0,global.game_measure,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_progress","set_shape",float($"../Spawner".sw-1)/global.sw_count,float($"../Spawner".sw)/global.sw_count,global.game_measure,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_progress_perfect","set_shape",0,1,global.game_measure,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		if global.curr_wv == 1:
			$"../progress".set("custom_colors/font_color",global.hex_color(6,1))
		timed_play()
		start_time += global.game_measure
		if scale_count == 0:
			interpolate_callback(self,start_time+global.move_time_new*2,"drone_timer",0,0,0)
		scale_count += 1
	else:
		for i in range(num_sounds):
			interpolate_callback($"../hex_subwave_capture",start_time,"collected_points",sw_score*(1-float(i+1)/num_sounds))
			interpolate_callback($"../hex_subwave",start_time,"total_points",norm-sw_score*(float(i+1)/num_sounds))
			interpolate_callback($"../hex_progress",start_time,"set_shape",float($"../Spawner".sw-1+float(i+1)/num_sounds)/global.sw_count)
			interpolate_callback($"../hex_progress",start_time,"play_note",-i,sw_score)
			start_time += global.harp_pluck_len
	#fill missing points
	#frac_fail_new = ($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/float(global.fail_thresh*($"../Spawner".accum_points.size()-1))#$"../Spawner".accum_points[-1]*fail_thresh)
	#print(frac_fail_new)
	num_sounds = round((norm-sw_score)*36*$"../Spawner".ball_per_sw) #/points_per_click
	frac_fail_new = frac_fail + num_sounds/float(global.fail_thresh*global.sw_count)
	#print(frac_fail_new)
	if num_sounds > 0:
		for i in range(num_sounds):
			interpolate_callback($"../hex_subwave",start_time,"total_points",(norm-sw_score)*(1-float(i+1)/num_sounds))
			interpolate_callback($"../hex_xed",start_time,"set_shape",frac_fail+(float(i+1)/num_sounds*(frac_fail_new-frac_fail)))
			interpolate_callback($"../typewriter",start_time,"play")
			start_time += global.harp_pluck_len*fail_time_ratio
	frac_fail = frac_fail_new
	if global.repeat_bad < 2 and num_sounds > global.fail_thresh:
		num_fails = fmod(num_fails+1,6)
	else:
		num_fails = 0
	if num_fails > 0:
		$"../Spawner".sw -= 1
	if frac_fail >= 1:
		interpolate_callback($"../..",start_time,"save_data",false)
	else:
		interpolate_callback($"../Spawner",start_time,"mySpawn")
	start()

func drone_timer(counter,indT,indB):
	if counter == 0:
		global.data["drone_play"].push_back(OS.get_ticks_msec())
	if $"../Spawner".notesT[indT].y == counter:
		play_timed_midi($"../Spawner".notesT[indT].x,$"../drone")
		indT += 1
	if $"../Spawner".notesB[indB].y == counter:
		play_timed_midi($"../Spawner".notesB[indB].x,$"../droneB",1)
		indB += 1
	counter += 1
	if counter >= play_state.z*global.measure_time:
		indT = 0
		indB = 0
		interpolate_callback(self,global.move_time_new + 12*global.move_time_new,"drone_timer",0,indT,indB)
	else:
		interpolate_callback(self,global.move_time_new/round(global.measure_time/8),"drone_timer",counter,indT,indB) #global.drone_measure/global.measure_time
	start()

func timed_play(st = start_time,  treb_stream = $"../spiccato",bass_stream = $"../spiccatoB", speedUp = 1):
	var st_t
	while play_state.x < $"../Spawner".notesB.size() and $"../Spawner".notesB[play_state.x].y < (play_state.z+1)*global.measure_time:
		st_t = st+ ($"../Spawner".notesB[play_state.x].y - play_state.z*global.measure_time)/global.measure_time*global.game_measure/speedUp
		interpolate_callback(self,st_t,"play_timed_midi",$"../Spawner".notesB[play_state.x].x,bass_stream,1)
		play_state.x += 1
	while play_state.y < $"../Spawner".notesT.size() and $"../Spawner".notesT[play_state.y].y < (play_state.z+1)*global.measure_time:
		st_t = st+ ($"../Spawner".notesT[play_state.y].y - play_state.z*global.measure_time)/global.measure_time*global.game_measure/speedUp
		interpolate_callback(self,st_t,"play_timed_midi",$"../Spawner".notesT[play_state.y].x,treb_stream)
		play_state.y += 1
	play_state.z += 1
	start()

func play_timed_midi(pitch,stream,offset = 0):
	stream.pitch_scale = pow(2,pitch/12.0-5+offset)
	stream.play()

func slide_hints(new):
	interpolate_method($"../hex_subwave_capture","collected_points",sw_score,sw_score+new,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	if global.curr_wv == 1:
		interpolate_method($"../percentage","set_prc",sw_score,sw_score+new,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score += new
	start()
	