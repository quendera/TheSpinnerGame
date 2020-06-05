extends Tween

var transition = TRANS_SINE
var ease_direction = EASE_IN_OUT
var lobe = PoolIntArray()
var choice = -1

func _ready():
	start()
	lobe.resize(2)

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			which_action(event.position-global.centre)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if choice == -3:
			$"../../move".play()
			reset_hints()
			choice = -1
			$"../accessory_screen".create(0)
		elif choice == -1:
			get_tree().quit()
		elif choice == 3:
			$"../../move".play()
			reset_hints()
			interpolate_method(self,"dim_levels",1,0,global.move_time_new,transition,ease_direction)#dim_levels()
			choice = -1
			start()

func which_action(click_loc):
	if choice == -3:
		$"../../move".play()
		reset_hints()
		choice = -1
		$"../accessory_screen".create(0)
	else:
		lobe[1] = fposmod(6-round(atan2(click_loc.x,click_loc.y)/PI*3),6)
		if int(sin(-(lobe[1])*PI/3)*click_loc.x+cos(-(lobe[1])*PI/3)*click_loc.y < 6*global.poly_size + global.side_offset):
			$"../../move".play()
			if choice == -1:
				if lobe[1] == 3:
					choice = lobe[1]
					#$"../../move".play()
					interpolate_method(self,"make_dim",0,1,global.move_time_new,transition,ease_direction)
				elif lobe[1] == 0:
					get_tree().quit()
				elif !is_active():
					choice = -3
					get_tree().call_group("hex_slider","hide")#make_dim",0)
					get_tree().call_group("menu_label","set_shape",1)
					$"../accessory_screen".create(lobe[1])
					#interpolate_method(self,"make_dim",1,0,global.move_time_new,transition,ease_direction)
			elif choice == 3:
				if global.is_unlocked(lobe[1]):
					#$"../../move".play()
					interpolate_method(self,"locked_sliders",1.001,2,global.move_time_new,transition,ease_direction)
					interpolate_method(self,"dim_levels",1,0,global.move_time_new,transition,ease_direction)
					choice = -2
					interpolate_callback($"../..",global.move_time_new,"start_level",lobe[1]+1)
		else:
			if choice != -1:
				$"../../move".play()
				reset_hints()
				interpolate_method(self,"dim_levels",1,0,global.move_time_new,transition,ease_direction)#dim_levels()
				choice = -1
	start()

func make_dim(dim):
	get_tree().call_group("hex_slider","make_dim",dim*.9)
	get_tree().call_group("menu_label","set_shape",dim)
	get_tree().call_group("menu_levels","set_rad",dim)

func reset_hints():
	interpolate_method(self,"reset_sliders",-6,0,global.move_time_new,transition,ease_direction)
	
func dim_levels(val):
	get_tree().call_group("menu_levels","set_bright",val)

func locked_sliders(wave_age):
	get_tree().call_group("hex_slider","locked_shape", wave_age,lobe[1])
	if wave_age == 2:
		get_tree().call_group("hex_slider","hide")

func reset_sliders(wave_age):
	get_tree().call_group("hex_slider","set_shape", wave_age,lobe)
	get_tree().call_group("menu_label","set_shape", wave_age)
