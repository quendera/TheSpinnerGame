extends Tween

var sw_score
var sw_total_points = 0

func reset_hints():
	#interpolate_property($"../Spawner".progress_line_instance,"sw_score",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	interpolate_method($"../Spawner".progress_line_instance,"set_shape",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	interpolate_method($"../progress_fields","my_update",sw_total_points,$"../Spawner".curr_wv_points/$"../Spawner".ball_per_sw/36.0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score = 0
	sw_total_points = $"../Spawner".curr_wv_points/$"../Spawner".ball_per_sw/36.0
	start()

func slide_hints(new):
	#interpolate_property($"../Spawner".progress_line_instance,"sw_score",-1,0,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	interpolate_method($"../Spawner".progress_line_instance,"set_shape",sw_score,sw_score+new,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	sw_score = sw_score + new
	start()
#
#func _on_progress_tween_tween_completed( object, key ):
#	#$"../Spawner".progress_line_instance.set_shape(sw_score)
#	#stop_all()
#	pass