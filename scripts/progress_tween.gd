extends Tween

var sw_score
var norm
var frac_fail = 0
var frac_fail_new
var fail_time_ratio = 3
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
	$"../spiccato".volume_db = -5
	$"../spiccatoB".volume_db = 0
	$"../drone".volume_db = -25
	$"../droneB".volume_db = -20

func reset_hints():
	#interpolate_method(self,"reset_sliders",-6,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score = 0
	norm = ($"../Spawner".curr_wv_points/($"../Spawner".ball_per_sw*36.0))
	slide_hints(0,4)
	#interpolate_method($"../hex_subwave","total_points",0,norm,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	$"../hex_subwave_capture".color = global.hex_color(6) 
	#$"../percentage".set_prc(0)
	interpolate_callback(self,global.move_time_new+global.harp_pluck_len,"remove_all")
	start()

func finish_hints_discrete():
	global.data["sw_time_end"].push_back(OS.get_ticks_msec())
	#num_sounds = ceil(sw_score*36*$"../Spawner".ball_per_sw) #/points_per_click
	start_time = global.move_time_new
	if sw_score == 0:
		$"../hex_progress_back/hex_progress".set_shape(float($"../Spawner".sw_played)/global.sw_count)
	elif round(sw_score*36*$"../Spawner".ball_per_sw) == $"../Spawner".curr_wv_points:
		slide_hints(sw_score,2,start_time)
	else:
		slide_hints(sw_score,1,start_time)
	num_sounds = round((norm-sw_score)*36*$"../Spawner".ball_per_sw) #/points_per_click
	frac_fail_new = frac_fail + num_sounds/float(global.fail_thresh*global.sw_count)
	if num_sounds > 0:
		start_time = start_time + global.move_time_new
		slide_hints(norm-sw_score,3,start_time)
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
		$"../..".write_data()
		interpolate_callback($"../Spawner",start_time,"mySpawn")
	start()

func play_timed_midi(pitch,stream,offset = 0):
	stream.pitch_scale = pow(2,pitch/12.0-5+offset)
	stream.play()

func slide_hints(new,mode,time = 0):
	if mode == 0:
		interpolate_method(self,"count_up",sw_score,sw_score+new,new*global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
		sw_score += new
	elif mode == 1:
		interpolate_method(self,"count_down",new,0,new*global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction,time)
		start_time += sw_score*global.move_time_new
	elif mode == 2:
		scale_count += 1
		play_state.z += 1
		#print(scale_count)
		#print(play_state.z)
		interpolate_method(self,"count_down_perfect",1,0,global.game_measure,$"../action_tween".transition,$"../action_tween".ease_direction,time)
		$"../hex_subwave_capture".color = global.hex_color(6,1) 
		#if global.curr_wv == 1:
		#	$"../progress".set("custom_colors/font_color",global.hex_color(6,1))
		#timed_play()
		start_time += global.game_measure
		if scale_count == 1:
			interpolate_callback($"../drone_tween",start_time+global.move_time_new,"drone_timer",0,0,0)
	elif mode == 3:
		interpolate_method(self,"count_down_damage",new,0,new*global.move_time_new*fail_time_ratio,$"../action_tween".transition,$"../action_tween".ease_direction,time)
		start_time += (norm-sw_score)*global.move_time_new*fail_time_ratio
	elif mode == 4:
		interpolate_method(self,"count_reset",0,1,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	start()

func count_reset(new):
#	reset_sliders(6*new-6)
	get_tree().call_group("hex_slider","set_shape", 6*new-6)
	$"../hex_subwave".total_points(new)

func count_up(new):
	$"../hex_subwave_capture".collected_points(new/norm)
	$"../hex_progress_back/hex_progress".play_note1(new)
	if global.curr_wv == 1:
		$"../percentage".set_prc(new)
		
func count_down(new):
	$"../hex_subwave_capture".collected_points(new/norm)
	$"../hex_subwave".total_points((new+norm-sw_score)/norm)
	$"../hex_progress_back/hex_progress".set_shape(($"../Spawner".sw_played-new/sw_score)/global.sw_count)
	$"../hex_progress_back/hex_progress".play_note1(new)
	
func count_down_perfect(new):
	$"../hex_subwave_capture".collected_points(new)
	#$"../hex_subwave".total_points(new)
	$"../hex_progress_back/hex_progress".set_shape(($"../Spawner".sw_played-new)/global.sw_count)
	$"../hex_progress_back/hex_progress_perfect".set_shape((scale_count-new)/global.sw_count)
	if new == 1:
		$"../hex_subwave".total_points(0)
		$"../hex_progress_back/hex_progress/smiley".modulate = global.hex_color(6,1)*2
	elif new == 0:
		$"../hex_progress_back/hex_progress/smiley".modulate = global.hex_color(6)*1.5
	if play_state.x < $"../Spawner".notesB.size() and $"../Spawner".notesB[play_state.x].y/float(global.measure_time) - play_state.z + 1 < 1-new:# float(play_state.z) 
		play_timed_midi($"../Spawner".notesB[play_state.x].x,$"../spiccatoB",1)
		play_state.x += 1
	if play_state.y< $"../Spawner".notesT.size() and  $"../Spawner".notesT[play_state.y].y/float(global.measure_time) - play_state.z + 1 < 1-new:
		play_timed_midi($"../Spawner".notesT[play_state.y].x,$"../spiccato")
		play_state.y += 1
		
func count_down_damage(new):
	$"../hex_subwave".total_points(new/norm)
	$"../hex_xed_back/hex_xed".set_shape(frac_fail_new-new/(norm-sw_score)*num_sounds/float(global.fail_thresh*global.sw_count))
	$"../typewriter".play()

#func timed_play(st = start_time,  treb_stream = $"../spiccato",bass_stream = $"../spiccatoB", speedUp = 1):
#	var st_t
#	while play_state.x < $"../Spawner".notesB.size() and $"../Spawner".notesB[play_state.x].y < (play_state.z+1)*global.measure_time:
#		st_t = st+ ($"../Spawner".notesB[play_state.x].y - play_state.z*global.measure_time)/global.measure_time*global.game_measure/speedUp
#		interpolate_callback(self,st_t,"play_timed_midi",$"../Spawner".notesB[play_state.x].x,bass_stream,1)
#		play_state.x += 1
#	while play_state.y < $"../Spawner".notesT.size() and $"../Spawner".notesT[play_state.y].y < (play_state.z+1)*global.measure_time:
#		st_t = st+ ($"../Spawner".notesT[play_state.y].y - play_state.z*global.measure_time)/global.measure_time*global.game_measure/speedUp
#		interpolate_callback(self,st_t,"play_timed_midi",$"../Spawner".notesT[play_state.y].x,treb_stream)
#		play_state.y += 1
#	play_state.z += 1
#	start()
