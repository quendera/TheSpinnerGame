extends Tween

var sw_score
var norm
var frac_fail = 0
var frac_fail_new
var fail_thresh = .2
var finish_point_seq_len = 1
var points_per_click = 1 #6
var click_len = .0
var fail_time_ratio = 3#(1-fail_thresh)/fail_thresh
var num_sounds
var start_time
var note_count = 0
var scale_time = global.move_time_new*6

func _ready():
	start()

func reset_hints():
	interpolate_method(self,"reset_sliders",-6,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../burn_progress","new_wave",0,1,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../hex_progress","set_shape",float($"../Spawner".sw)/($"../Spawner".accum_points.size()),float($"../Spawner".sw+1)/($"../Spawner".accum_points.size()),global.move_time_new/2,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new/2)
	sw_score = 0
	norm = ($"../Spawner".curr_wv_points/($"../Spawner".ball_per_sw*36.0)) #sqrt
	#interpolate_property($"../hex_subwave","scale",Vector2(0,0),norm*Vector2(1,1),global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new)
	interpolate_method($"../hex_subwave","total_points",0,norm,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new)#$"../Spawner".curr_wv_points*click_len
	$"../hex_subwave_capture".color = global.hex_color(6) 

func reset_sliders(wave_age):
	get_tree().call_group("hex_slider","set_shape", wave_age)

func finish_hints_discrete():
	num_sounds = ceil(sw_score*36*$"../Spawner".ball_per_sw/points_per_click)
	start_time = 0#global.move_time_new
	if num_sounds == 0:
		$"../hex_progress".set_shape(float($"../Spawner".sw)/global.sw_count)
	elif round(sw_score*36*$"../Spawner".ball_per_sw) == $"../Spawner".curr_wv_points:
		$"../hex_subwave_capture".color = global.hex_color(6,1) 
		#interpolate_method($"../hex_perfect","dim_hex",1,0,scale_time,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_subwave_capture","collected_points",sw_score,0,scale_time,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_subwave","total_points",sw_score,0,scale_time,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_progress","set_shape",float($"../Spawner".sw-1)/global.sw_count,float($"../Spawner".sw)/global.sw_count,scale_time,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		interpolate_method($"../hex_progress_perfect","set_shape",0,1,scale_time,$"../action_tween".transition,$"../action_tween".ease_direction,start_time)
		#$"../perfect".play() too subtle
		for i in range($"../hex_progress_perfect".notes_per_scale):
			interpolate_callback($"../hex_progress_perfect",start_time,"play_midi",i)
			start_time += scale_time/float($"../hex_progress_perfect".notes_per_scale)
		$"../hex_progress_perfect".scale_count += 1
		#note_count += notes_per_scale
		#interpolate_property($"../hex_subwave_capture",color,global.hex_color(6,1),global
		#interpolate_callback($"../hex_progress",start_time,"set_shape",float($"../Spawner".sw-1+float(i+1)/num_sounds)/$"../Spawner".accum_points.size())
		##interpolate_method($"../hex_subwave","set_shape",1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	else:
		for i in range(num_sounds):
			interpolate_callback($"../hex_subwave_capture",start_time,"collected_points",sw_score*(1-float(i+1)/num_sounds))
			interpolate_callback($"../hex_subwave",start_time,"total_points",norm-sw_score*(float(i+1)/num_sounds))
			interpolate_callback($"../hex_progress",start_time,"set_shape",float($"../Spawner".sw-1+float(i+1)/num_sounds)/global.sw_count)
			interpolate_callback($"../hex_progress",start_time,"play_note",-i)
			#interpolate_callback($"../collect4",start_time,"play")
			start_time += global.harp_pluck_len
	#fill missing points
#	var tween_loss_len = click_len*max(1,(norm-sw_score)*36*$"../Spawner".ball_per_sw)*fail_time_ratio
	frac_fail_new = ($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/(fail_thresh*$"../Spawner".accum_points[-1])
	num_sounds = ceil((norm-sw_score)*36*$"../Spawner".ball_per_sw/points_per_click)
	if num_sounds == 0:
		pass#interpolate_callback($"../collect6",start_time,"play")
	else:
		for i in range(num_sounds):
			interpolate_callback($"../hex_subwave",start_time,"total_points",(norm-sw_score)*(1-float(i+1)/num_sounds))
			interpolate_callback($"../hex_xed",start_time,"set_shape",frac_fail+(float(i+1)/num_sounds*(frac_fail_new-frac_fail)))
			interpolate_callback($"../typewriter",start_time,"play")
			start_time += global.harp_pluck_len*fail_time_ratio
	frac_fail = frac_fail_new
	#generate new wave
	interpolate_callback($"../Spawner",start_time,"mySpawn")
	

func slide_hints(new):
	#interpolate_property($"../hex_subwave","scale",Vector2(1,1)*norm*sqrt(1-sw_score),Vector2(1,1)*norm*sqrt(max(0,1-sw_score-new)),global.move_time_new/2,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new/2)
	#$"../hex_subwave".add_line()
	interpolate_method($"../hex_subwave_capture","collected_points",sw_score,sw_score+new,global.move_time_new/2,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new/2)
	#sw_score = min(1,sw_score + new)
	sw_score += new

	#interpolate_property($"../Spawner".progress_line_instance,"sw_score",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../Spawner".progress_line_instance,"set_shape",sw_score,sw_score+new,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	
	#var dist_to_fail = (1-($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/float((1-$"../progress_full".pass_thresh)*$"../Spawner".accum_points[-1]))
	#$"../progress_full_line".set_shape()#update()
	#interpolate_property($"../Spawner".progress_line_instance,"sw_score",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../Spawner".progress_line_instance,"set_shape",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../progress_fields","my_update",sw_total_points,$"../Spawner".curr_wv_points/$"../Spawner".ball_per_sw/36.0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_property($"../hex_progress","scale",sqrt(1-$"../Spawner".accum_points[$"../Spawner".sw]/float($"../Spawner".accum_points[-1]))*Vector2(1,1),sqrt(1-$"../Spawner".accum_points[$"../Spawner".sw+1]/float($"../Spawner".accum_points[-1]))*Vector2(1,1),global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
#	interpolate_method($"../hex_progress","set_shape",
	#float($"../Spawner".accum_points[-1]))
#	sw_total_points = $"../Spawner".curr_wv_points

#func finish_hints():
#	var tween_len = click_len*max(1,sw_score*36*$"../Spawner".ball_per_sw)
#	interpolate_method($"../hex_subwave","collected_points",sw_score,0,tween_len,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new)
#	interpolate_method($"../hex_subwave","total_points",norm,norm-sw_score,tween_len,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new)
#	#fill collected points in next line
#	interpolate_method($"../hex_progress","set_shape",float($"../Spawner".sw-1)/($"../Spawner".accum_points.size()),float($"../Spawner".sw)/($"../Spawner".accum_points.size()),tween_len,$"../action_tween".transition,$"../action_tween".ease_direction,global.move_time_new)
#	num_sounds = ceil(max(1,sw_score*36*$"../Spawner".ball_per_sw)/points_per_click)
#	for i in range(num_sounds):
#		interpolate_callback($"../collect4",global.move_time_new+i*points_per_click*click_len,"play")
#	#fill missing points
#	var tween_loss_len = click_len*max(1,(norm-sw_score)*36*$"../Spawner".ball_per_sw)*fail_time_ratio
#	interpolate_method($"../hex_subwave","total_points",norm-sw_score,0,tween_loss_len,$"../action_tween".transition,$"../action_tween".ease_direction,tween_len+global.move_time_new)
#	frac_fail_new = ($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/(fail_thresh*$"../Spawner".accum_points[-1])
#	interpolate_method($"../hex_xed","set_shape",frac_fail,frac_fail_new,tween_loss_len,$"../action_tween".transition,$"../action_tween".ease_direction,tween_len+global.move_time_new)
#	num_sounds = ceil((norm-sw_score)*36*$"../Spawner".ball_per_sw/points_per_click)
#	if num_sounds == 0:
#		interpolate_callback($"../collect6",global.move_time_new+tween_len,"play")
#	else:
#		for i in range(num_sounds):
#			interpolate_callback($"../collect1",global.move_time_new+tween_len+i*points_per_click*click_len*fail_time_ratio,"play")
#	frac_fail = frac_fail_new
#	#interpolate_property($"../hex_subwave","scale",Vector2(1,1)*norm*sqrt(1-sw_score),Vector2(0,0),global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
#	#generate new wave
#	interpolate_callback($"../Spawner",global.move_time_new+tween_loss_len+tween_len,"mySpawn")


#func _on_progress_tween_tween_completed( object, key ):
#	#$"../Spawner".progress_line_instance.set_shape(sw_score)
#	#stop_all()
#	pass