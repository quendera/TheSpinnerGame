extends Tween

var sw_score
var norm
var frac_fail = 0
var frac_fail_new
var fail_thresh = .2
#var sw_total_points = 0

func reset_hints():
	frac_fail_new = ($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/(fail_thresh*$"../Spawner".accum_points[-1])
	#var dist_to_fail = (1-($"../Spawner".accum_points[$"../Spawner".sw] - global.score)/float((1-$"../progress_full".pass_thresh)*$"../Spawner".accum_points[-1]))
	interpolate_method($"../hex_xed","set_shape",frac_fail,frac_fail_new,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	frac_fail = frac_fail_new
	#$"../progress_full_line".set_shape()#update()
	#interpolate_property($"../Spawner".progress_line_instance,"sw_score",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../Spawner".progress_line_instance,"set_shape",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../progress_fields","my_update",sw_total_points,$"../Spawner".curr_wv_points/$"../Spawner".ball_per_sw/36.0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	interpolate_property($"../hex_progress","scale",sqrt(1-$"../Spawner".accum_points[$"../Spawner".sw]/float($"../Spawner".accum_points[-1]))*Vector2(1,1),sqrt(1-$"../Spawner".accum_points[$"../Spawner".sw+1]/float($"../Spawner".accum_points[-1]))*Vector2(1,1),global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score = 0
	norm = sqrt($"../Spawner".curr_wv_points/($"../Spawner".ball_per_sw*36.0))#float($"../Spawner".accum_points[-1]))
#	sw_total_points = $"../Spawner".curr_wv_points
	interpolate_property($"../hex_subwave","scale",Vector2(0,0),norm*Vector2(1,1),global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	start()

func slide_hints(new):
	#interpolate_property($"../Spawner".progress_line_instance,"sw_score",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	#interpolate_method($"../Spawner".progress_line_instance,"set_shape",sw_score,sw_score+new,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	interpolate_property($"../hex_subwave","scale",Vector2(1,1)*norm*sqrt(1-sw_score),Vector2(1,1)*norm*sqrt(1-sw_score-new),global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score = sw_score + new
	start()
#
#func _on_progress_tween_tween_completed( object, key ):
#	#$"../Spawner".progress_line_instance.set_shape(sw_score)
#	#stop_all()
#	pass