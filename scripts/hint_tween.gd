extends Tween

var counter

func slide_hints():
	interpolate_property(self,"counter",0,1,global.move_time_new,$"../action_tween".transition,$"../action_tween".ease_direction)
	start()

func _on_hint_tween_tween_step( object, key, elapsed, value ):
	get_tree().call_group("hint_slide", "set_shape", counter)

func _on_hint_tween_tween_completed( object, key ):
	get_tree().call_group("hint_slide", "set_shape_finish")
	stop_all()
