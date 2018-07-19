extends Tween

var location_queue = PoolIntArray()
var action_queue = PoolIntArray() #-1: CCW, 0: advance, 1: CW, 2: collect
var wave_age
var collection_sequence
var transition = TRANS_SINE
var ease_direction = EASE_IN_OUT#OUT
var last_press_loc = Vector2(0,0)
var curr_press_loc
var drag_vel
var motion_thresh = OS.get_screen_dpi()*.1 #pixels
#var hold_thresh = global.move_time_new/2*1000

func _ready():
	pass#playback_process_mode = TWEEN_PROCESS_PHYSICS

func _input(event):
	if event is InputEventKey:
		get_tree().get_root().get_node("hex_root").save_data(false)
	elif event is InputEventScreenTouch and wave_age >= 0:
		if event.is_pressed():
			global.data["mo_press_time"].push_back(OS.get_ticks_msec())
			last_press_loc = event.position-global.centre
			global.data["mo_press_x"].push_back(last_press_loc.x)
			global.data["mo_press_y"].push_back(last_press_loc.y)
		else:#if event.is_released():
			which_action(event.position-global.centre)
	else:
		curr_press_loc = event.position - global.centre
		if event is InputEventScreenDrag:#not event is InputEventMouseMotion:
			global.data["mo_move_time"].push_back(OS.get_ticks_msec())
			global.data["mo_move_pos_x"].push_back(curr_press_loc.x)
			global.data["mo_move_pos_y"].push_back(curr_press_loc.y)

func reset():
	wave_age = -6
	collection_sequence = 0
	location_queue.resize(2)
	location_queue[0] = -1
	location_queue[1] = -1
	action_queue.resize(1)
	#$"../move".play()
	interpolate_property(self,"wave_age",wave_age,0,global.move_time_new,transition,ease_direction)
	start()

func add_to_queue(lobe,dragged):
	if location_queue[-1] == -1:
		location_queue.append(lobe-1)
		action_queue.append(0)
		if dragged:
			location_queue.append(lobe-1)
			action_queue.append(2)
		take_action()
	else:
		var vel = calc_ang_vel(location_queue[-1],lobe-1)
		if vel == 0:# and wave_age + action_queue.size() < 6+$"../Spawner".ball_per_sw:
			location_queue.append(location_queue[-1])
			action_queue.append(2*int(dragged))
		else:
			while vel != 0:# and wave_age + action_queue.size() < 6+$"../Spawner".ball_per_sw:
				location_queue.append(fposmod(location_queue[-1]-vel,6))
				action_queue.append(vel)
				vel = calc_ang_vel(location_queue[-1],lobe-1)
			if dragged:# lobe < 0:
				location_queue.append(location_queue[-1])
				action_queue.append(2)
		if !is_active():
			take_action()

#remove next if problme
func take_action():
	if $"../Spawner".balls_left > 0:# or wave_age <= 0:
		if action_queue.size() > 0 and action_queue[0] == 2:
			get_tree().call_group("hex_balls", "get_collected", location_queue[1])
			interpolate_property(self,"collection_sequence",.001,1,global.move_time_new,transition, EASE_OUT)
		else:
			$"../move".play()
			interpolate_property(self,"wave_age",wave_age+.001,wave_age+1,global.move_time_new,transition,ease_direction)
	start()

func calc_ang_vel(curr_loc,new_loc):
	if curr_loc == new_loc:
		return 0
	elif fposmod(curr_loc-new_loc,6) > 3:
		return -1
	else:
		return 1

func which_action(click_loc):
	var lobe = fposmod(6-round(atan2(last_press_loc.x,last_press_loc.y)/PI*3),6)
	var lobe_angle = (lobe)*PI/3
	global.data["mo_time"].push_back(OS.get_ticks_msec())
	global.data["mo_x"].push_back(click_loc.x)
	global.data["mo_y"].push_back(click_loc.y)
	global.data["mo_lobe"].push_back((lobe+1)*int(sin(-lobe_angle)*last_press_loc.x+cos(-lobe_angle)*last_press_loc.y < 6*global.poly_size + global.side_offset))
	global.data["mo_act_drag"].push_back(int((last_press_loc - click_loc).length() > motion_thresh))
	global.data["mo_fake_release"].push_back(int(global.data["mo_press_time"].size() == 0 or (global.data["mo_time"].size() > 1 and global.data["mo_press_time"].size() > 0 and global.data["mo_time"][-2] > global.data["mo_press_time"][-1])))
	if global.data["mo_lobe"][-1] > 0 and !global.data["mo_fake_release"][-1]:
		add_to_queue(global.data["mo_lobe"][-1],global.data["mo_act_drag"][-1])#(global.data["mo_time"][-1]-global.data["mo_press_time"][-1]) > hold_thresh)

func _on_action_tween_tween_completed( object, key ):
	global.data["mo_act_taken_time"].push_back(OS.get_ticks_msec())
	global.data["mo_act_taken_act"].push_back(action_queue[0])
	global.data["mo_act_taken_pos"].push_back(location_queue[1])
	#global.data["mo_act_taken_age"].push_back(wave_age)
	stop_all()
	if collection_sequence > 0:
		get_tree().call_group("hex_balls", "run_collection", collection_sequence)
		collection_sequence = 0
	else:
		$"../dividers".update()
		get_tree().call_group("hint_balls", "set_shape", wave_age)
		get_tree().call_group("hex_balls", "set_shape", wave_age)
		if wave_age > 0:
			get_tree().call_group("hex_slider","set_shape", wave_age,location_queue,action_queue,1)
	location_queue.remove(0)
	action_queue.remove(0)
	if action_queue.size() != 0 or wave_age < 0:
		take_action()

func _on_action_tween_tween_step( object, key, elapsed, value ):
	if collection_sequence > 0:
		get_tree().call_group("hex_balls", "run_collection", collection_sequence)
	else:
		$"../dividers".update()
		get_tree().call_group("hint_balls", "set_shape", wave_age)
		get_tree().call_group("hex_balls", "set_shape", wave_age)
		if wave_age > 0:
			get_tree().call_group("hex_slider","set_shape", wave_age,location_queue,action_queue)