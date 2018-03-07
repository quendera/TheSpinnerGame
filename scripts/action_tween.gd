extends Tween

var location_queue = PoolIntArray()
var action_queue = PoolIntArray() #-1: CCW, 0: advance, 1: CW, 2: collect
var time_queue = PoolIntArray()
var wave_age
var collection_sequence
var transition = TRANS_SINE
var ease_direction = EASE_IN_OUT#OUT
var data_line = {"mo_time":0,"mo_x":0, "mo_y":0, "mo_press":0,"mo_lobe":0}
var last_press_loc = Vector2(0,0)
var curr_press_loc
var drag_vel
var motion_thresh = OS.get_screen_dpi()*.1 #pixels
#var total_drag = Vector2(0,0)
#var delay_timer = Timer()
#signal delay_action
#var delay_msec = 1

func _ready():
	pass
#	connect("delay_action",

func _input(event):
	if event is InputEventScreenTouch:
		log_data_mo(event.position-global.centre,event.is_pressed())
	else:
		curr_press_loc = event.position - global.centre
#	if event is InputEventScreenTouch and event.is_pressed():
#		print(OS.get_ticks_msec())
#		drag_flag = 0
#		total_drag = Vector2(0,0)
#		add_to_queue(which_action(event.position-global.centre))
##		total_drag = Vector2(0,0)
##		total_speed = Vector2(0,0)
#	if event is InputEventScreenDrag:
#		total_drag += event.relative
#		print(total_drag.length())
#		if !drag_flag and total_drag.length() > min_drag:# and event.relative.length() > min_drag: #total_drag.length() > min_drag:
#			action_queue.append(2)
#			location_queue.append(location_queue[-1])
#			drag_flag = 1
#	if event is InputEventScreenTouch and !event.is_pressed():
#		print([OS.get_ticks_msec()])
		
		
func reset():
	wave_age = -6#global.curr_wv
	collection_sequence = 0
	location_queue.resize(1)
	location_queue[0] = -1
	action_queue.resize(0)
	#take_action()
	$"../move".play()
	interpolate_property(self,"wave_age",wave_age,0,global.move_time_new,transition,ease_direction)
	start()

func add_to_queue(lobe,dragged):
	if location_queue[-1] == -1:
		location_queue.append(lobe-1)
		action_queue.append(0)#2*int(dragged)) #FIX THIS TO ALLOW FIRST COLLECTION
		if dragged:
			location_queue.append(lobe-1)
			action_queue.append(2)
		take_action()
	else:
		var vel = calc_ang_vel(location_queue[-1],lobe-1)
		if vel == 0:
			location_queue.append(location_queue[-1])
			action_queue.append(2*int(dragged))
#			$"../check_drag_timer".start()
		else:
			while vel != 0:
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
	if action_queue.size() > 0 and action_queue[0] == 2:
		#run collection tween
		get_tree().call_group("hex_balls", "get_collected", location_queue[1])
		location_queue.remove(0)
		action_queue.remove(0)
		interpolate_property(self,"collection_sequence",0,1,global.move_time_new,transition, EASE_OUT)
	else:
		$"../move".play()
		interpolate_property(self,"wave_age",wave_age,wave_age+1,global.move_time_new,transition,ease_direction)
#		get_tree().call_group("balls", "step")
#		if action_queue != 0:
#			$"../triSpinner".move_slider(action_queue[0])
	start()

func calc_ang_vel(curr_loc,new_loc):
	if curr_loc == new_loc:
		return 0
	elif fposmod(curr_loc-new_loc,6) > 3:
		return -1
	else:
		return 1

func log_data_mo(mo_pos,pressed):
	if pressed and which_action(mo_pos) > 0:
		$"../action_timer".start()
		last_press_loc = mo_pos
	data_line["mo_time"] = global.dt
	data_line["mo_x"] = mo_pos.x
	data_line["mo_y"] = mo_pos.y
	data_line["mo_press"] = int(pressed)
	data_line["mo_lobe"] = which_action(mo_pos)
	for key in data_line.keys():
		global.data[key].push_back(data_line[key])
		
func which_action(click_loc):
	var lobe = fposmod(6-round(atan2(click_loc.x,click_loc.y)/PI*3),6)
	var lobe_angle = (lobe)*PI/3
	var dist = sin(-lobe_angle)*click_loc.x+cos(-lobe_angle)*click_loc.y
	return (lobe+1)*int(dist < 12*global.poly_size + global.side_offset)

func _on_action_tween_tween_completed( object, key ):
	stop_all()
	if collection_sequence > 0:
		get_tree().call_group("hex_balls", "run_collection", collection_sequence)
		collection_sequence = 0
	else:
		$"../dividers".update()
		get_tree().call_group("hint_balls", "set_shape", wave_age)
		get_tree().call_group("hex_balls", "set_shape", wave_age)
		if action_queue.size() != 0:
			location_queue.remove(0)
			action_queue.remove(0)
		$"../triSpinner".global_rotation = location_queue[0]*PI/3
	if action_queue.size() != 0 or wave_age < 0:
		take_action()

func _on_action_tween_tween_step( object, key, elapsed, value ):
	if collection_sequence > 0:
		get_tree().call_group("hex_balls", "run_collection", collection_sequence)
	else:
		$"../dividers".update()
		if action_queue.size() > 0 and abs(action_queue[0]) == 1:
			$"../triSpinner".global_rotation = PI/3*(location_queue[1] + action_queue[0]*(1-fmod(wave_age,1)))
		if location_queue[0] == -1:
			pass#grow spinner
	#	if action_queue.size() > 1 and action_queue[1] == 2 and location_queue[0] == location_queue[2]:
	#		wave_age = floor(wave_age)
	#		stop_all()
	#		action_queue.remove(0)
	#		location_queue.remove(0)
	#		take_action()
	#	else:
		get_tree().call_group("hint_balls", "set_shape", wave_age)
		get_tree().call_group("hex_balls", "set_shape", wave_age)

func _on_action_timer_timeout():
	drag_vel = last_press_loc - curr_press_loc
	add_to_queue(which_action(last_press_loc),drag_vel.length() > motion_thresh)