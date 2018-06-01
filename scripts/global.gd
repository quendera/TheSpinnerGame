extends Node

var w = 1920
var h = 1080
var padding = .15
var centre = Vector2(round(w-h/sqrt(3)),h*.5)
var harp_pluck_len = .01*5/6.0
var move_time_new = 36*harp_pluck_len#/6 #1.0/3
var offset_poly_ratio = .3
var poly_size = ((1-padding)*h)/2/(6+offset_poly_ratio)#w/50
var side_offset = poly_size*offset_poly_ratio
var sw_count
var curr_wv
var sw_score
var score
var save_file_name
var data
var measure_time
var game_measure
var drone_measure
var fail_thresh
var hi_scores = PoolIntArray([0,0,0,0,0,0])
var max_scores = PoolIntArray([216,740,1780,3414,8301,9805])
var num_waves = PoolIntArray([6,12,20,30,60,60])
var fnt = DynamicFont.new()

func full_hex(radius,wire =0,off = Vector2(0,0)):
	var coords = PoolVector2Array()
	for i in range(6+wire):
		coords.append(Vector2(cos(float(i)/3*PI),sin(float(i)/3*PI))*radius+off)
	return coords

func init(lev,device_ID):#,player_name = "",player_ID = 0):
	AudioServer.set_bus_volume_db(4,-35)
	AudioServer.set_bus_volume_db(6,-30)
	global.curr_wv = lev
	global.sw_score = 0
	global.score = 0
	global.save_file_name = "user://data" + str(OS.get_unix_time())+".json"
	global.data = {"mo_time":[],"mo_x":[], "mo_y":[],"mo_lobe":[], "mo_press_time":[], #"mo_press":[],"ke_time":[], "ke_pos":[], "ke_ID":[], "ke_startstep":[],
	"mo_act_drag":[],"mo_move_time":[],"mo_move_pos_x":[],"mo_move_pos_y":[],"mo_fake_release":[], #"mo_act_drag_time":[],
	"mo_act_taken_time":[],"mo_act_taken_act":[],"mo_act_taken_pos":[],"mo_press_x":[], "mo_press_y":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], #"ba_ID_mv":[], "ba_time_mv":[],
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(),
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize_x":OS.get_screen_size().x,"device_screensize_y":OS.get_screen_size().y,
	"device_timezone":OS.get_time_zone_info(),"device_dpi":OS.get_screen_dpi(),
	"device_IP": IP.get_local_addresses(),# "player_name": player_name,"player_ID":player_ID,
	"device_ID_time":device_ID.x,"device_ID_rand":device_ID.y,
	"OS_start_time": OS.get_ticks_msec(), "drone_play": [], "failure_thresh":global.fail_thresh}

func pie_hex(full,angle):
	angle *= 6
	var coords = PoolVector2Array(full)
	if angle >= 6:
		coords.resize(6)
	elif angle > 0.01:
		coords.insert(0,Vector2(0,0))
		coords.resize(ceil(angle)+2)
		angle = fmod(angle,1)
		if angle > 0:
			angle = max(angle,.001)
			coords[coords.size()-1] = full[coords.size()-2]*angle+full[coords.size()-3]*(1-angle)
	else:
		coords.resize(0)
	return coords
	
func is_unlocked(lobe):
	if lobe == 0:
		return true
	else:
		return global.hi_scores[lobe-1] > global.max_scores[lobe-1]-global.fail_thresh*global.num_waves[lobe-1]

func hex_color(rad,invert=false,dim = 1):
	var col = Color()
	col.v = float(rad+2)/(6+2)
	col.s = 1
	col.h = 22.0/360#2/12.0 sucks all else 1-5 good??
	if invert:
		col.h = fmod(col.h+.5,1)
	col.a = dim
	return col
	
func hint_color(rad):
	var col = float(rad+2)/(18+2)
	return Color(col,col,col)

##background - 255,0,59
##slider - 11,153,204
#targets - 0,224,194 #255,125

#func which_color(rad):
#	var col = Color()
##	col.r = 1-float(rad-1)/11#min(1,float(rad-1)/11*2)
##	col.g = col.r
##	col.b = float(rad-1)/11#min(1,2-float(rad-1)/11*2)
#	var minSize = -2
#	var gain = float(rad-minSize)/(12-minSize) #max(7,rad)
#	#gain = gain*gain
#	if rad <= 6:
#		col.r = 1#float(rad)/6
#		col.g = col.r
#		col.b = col.r
#	else: 
##		#col.r = min(1,float(rad-12)/5*2+2)
##		#col.g = min(1,float(12-rad)/5*2)
##		col.g = 1#0#min(1,float(12-rad)/6)
##		col.r = float(237)/255#0#col.g
##		#col.r = cos(float(11-rad+1)/11*PI)#col.s = 1
##		#col.g = sin(float(11-rad+1)/11*PI)#col.h = fposmod(float(-.5-rad)/13,1)		
##		col.b = float(33)/255#1#col.r
#		col.v = 1
#		col.s = 1
#		#col.h = float(172)/360
#		#col.h = float(336)/360
#		col.h = float(22)/360
#	return col*gain
	
#func spiral_peel(frac):
#	frac = min(1,frac)
#	frac *= 1#progress_frac[-1]
#	var coords = progress_spiral
#	var ind = progress_frac.bsearch(frac)
#	coords.resize(ind+1)
#	if ind > 0:
#		var weight = (progress_frac[ind]-frac)/(progress_frac[ind]-progress_frac[ind-1])
#		coords[-1] = (1-weight)*coords[-1] + (weight)*coords[-2]
#	return coords
#
#func spiral_hex():
#	progress_spiral.resize(n_vertex*progress_loops+1)
#	progress_frac.resize(n_vertex*progress_loops+1)
#	var offset = progress_rad*Vector2(cos(float(1)/n_vertex*2*PI),sin(float(1)/n_vertex*2*PI))
#	progress_frac[0] = 0
#	for i in range(progress_loops):
#		for j in range(n_vertex):
#			progress_frac[i*n_vertex+j+1] = progress_frac[i*n_vertex+j] + i+1
#			progress_spiral[i*n_vertex+j+1] = Vector2(cos(float(j+1)/n_vertex*2*PI),sin(float(j+1)/n_vertex*2*PI))*(i+1)*progress_rad
#			if j == n_vertex - 1 and i < progress_loops - 1:
#				progress_spiral[i*n_vertex+j+1] += offset
#				progress_frac[i*n_vertex+j+1] += 1
#			elif j == 0 and i > 0:
#				progress_frac[i*n_vertex+j+1] -= 1
#
#func maze_hex(radius,numTargets):
#	var layers = ceil(sqrt(float(numTargets)/6))
#	var base 
#	var coords = PoolVector2Array()
#	var offset = radius*Vector2(cos(float(1)/3*PI),sin(float(1)/3*PI))
#	for i in range(layers):
#		base = float(numTargets - 6*pow(i,2))/(2*i+1)
#		for j in range(min(6,ceil(base))):
#			coords.append(Vector2(cos(float(j+1)/3*PI),sin(float(j+1)/3*PI))*(i+1)*radius)
#			if j == 5 and i < layers - 1:
#				coords[-1] += offset
#	return coords


#var progress_loops = 10
#var progress_rad = poly_size#/10.0*8 #20/sqrt(accum_points[-1])
#var side_offset = float(progress_rad)
#var progress_spiral = PoolVector2Array()
#var progress_frac = Array()
#var progress_draw_time = 1
#var start_step
#var sw_end_flag = 0