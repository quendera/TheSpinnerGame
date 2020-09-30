extends Node

var w = 1024#1920
var h = 600 #1080
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
#var score
var save_file_name
var data
var measure_time
var game_measure
var drone_measure
var fail_thresh
var make_rand
var repeat_bad
var max_level = 0
var level_scores = PoolIntArray([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1])
var total_score = 0
var max_score
var num_waves = PoolIntArray([6,12,20,30,30,30])#60,60])
var fnt = DynamicFont.new()
var menu_opened = 0
var scorebar_mode = 1
var stretch = h*(1-padding)-poly_size*2/sqrt(3)
var scorebar_anchor = poly_size*1.5

func full_hex(radius,wire =0,off = Vector2(0,0)):
	var coords = PoolVector2Array()
	for i in range(6+wire):
		coords.append(Vector2(cos(float(i)/3*PI),sin(float(i)/3*PI))*radius+off)
	return coords
	
func score_hex(radius,off = Vector2(0,0),stretchy = Vector2(0,0),wire = 0):
	var coords = PoolVector2Array()
	for i in range(6+wire):
		coords.append(Vector2(sin(float(i)/3*PI),cos(float(i)/3*PI))*radius+off+int(i>1 and i < 5)*stretchy)
	return coords
	
	
func full_tri(radius,wire =0,off = Vector2(0,0)):
	var coords = PoolVector2Array()
	for i in range(3+wire):
		coords.append(Vector2(sin(float(i)/1.5*PI),-cos(float(i)/1.5*PI))*radius+off)
	return coords

func init(lev,device_ID,num_saves):
	global.curr_wv = lev
	global.sw_score = 0
	#global.score = 0
	global.save_file_name = str(OS.get_unix_time())
	global.data = {"mo_time":[],"mo_x":[], "mo_y":[],"mo_lobe":[], "mo_press_time":[],
	"mo_act_drag":[],"mo_move_time":[],"mo_move_pos_x":[],"mo_move_pos_y":[],"mo_fake_release":[], 
	"mo_act_taken_time":[],"mo_act_taken_act":[],"mo_act_taken_pos":[],"mo_press_x":[], "mo_press_y":[],
	"ba_time":[], "ba_position":[], "ba_ID":[], "ba_age":[], "sw_time_end":[],
	"sw_time":[], "sw_subwave_num":[], "sw_offset":[], "sw_flip" : [], "level":lev,
	"device_current_time":OS.get_datetime(), "device_OS": OS.get_name(),
	"device_kb_locale":OS.get_locale(), "device_name":OS.get_model_name(),
	"device_screensize_x":OS.get_screen_size().x,"device_screensize_y":OS.get_screen_size().y,
	"device_timezone":OS.get_time_zone_info(),"device_dpi":OS.get_screen_dpi(),
	"device_IP": IP.get_local_addresses(),"device_ID":OS.get_unique_id(),
	"device_ID_time":device_ID.x,"device_ID_rand":device_ID.y,
	"device_video_driver":OS.get_current_video_driver(),
	"OS_start_time": OS.get_ticks_msec(), "drone_play": [], "focus_in":[], "focus_out":[], 
	"failure_thresh":global.fail_thresh,"rand_pos": global.make_rand, "repeat_bad": global.repeat_bad,
	"user_quit":false,"level_won":false,"level_end_time":0,"level_scores":level_scores,
	"total_saves":num_saves,"max_unlocked":max_level ,"version":1.12}

func pie_hex(coords,angle):
	angle *= 6
	#var coords = PoolVector2Array(full)
	if angle >= 6:
		coords.resize(6)
	elif angle > 0.01:
		coords.insert(0,Vector2(0,0))
		coords.resize(ceil(angle)+2)
		angle = fmod(angle,1)
		if angle > 0:
			angle = max(angle,.001)
			coords[coords.size()-1] = coords[coords.size()-1]*angle+coords[coords.size()-2]*(1-angle)
	else:
		coords.resize(0)
	return coords
	
func is_unlocked(lobe):
	return lobe <= global.max_level

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
	var col = float(rad+2)/(10+2)
	return Color(col,col,col)
