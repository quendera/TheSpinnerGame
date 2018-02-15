extends Node

var w = 1280
var h = 720
var cx = w*.65#/2
var cy = h/2
var centre = Vector2(cx,cy)
var move_time_new = .2
var poly_size = w/47
var sw_count
var curr_wv
var total_time
var sw_score
var score
var dt
var start_step
var save_file_name
var data
var sw_end_flag = 0
var neon_offset = Vector2(0,-360)

func _ready():
	pass
	
func pie_hex(full,angle):
	var coords = PoolVector2Array(full)
	coords.insert(0,Vector2(0,0))
	coords.resize(ceil(angle)+2)
	angle = fmod(angle,1)
	if angle > 0:
		coords[coords.size()-1] = full[coords.size()-2]*angle+full[coords.size()-3]*(1-angle)
	return coords
	
func full_hex(radius,wire):
	var coords = PoolVector2Array()
	for i in range(6+wire):
		coords.append(Vector2(cos(float(i)/3*PI),sin(float(i)/3*PI))*radius)
	return coords
	
##background - 255,0,59
##slider - 11,153,204
#targets - 0,224,194 #255,125
#slider - 

func which_color(rad):
	var col = Color()
#	col.r = 1-float(rad-1)/11#min(1,float(rad-1)/11*2)
#	col.g = col.r
#	col.b = float(rad-1)/11#min(1,2-float(rad-1)/11*2)
	var minSize = -2
	var gain = float(rad-minSize)/(12-minSize) #max(7,rad)
	#gain = gain*gain
	if rad <= 6:
		col.r = 1#float(rad)/6
		col.g = col.r
		col.b = col.r
	else: 
#		#col.r = min(1,float(rad-12)/5*2+2)
#		#col.g = min(1,float(12-rad)/5*2)
#		col.g = 1#0#min(1,float(12-rad)/6)
#		col.r = float(237)/255#0#col.g
#		#col.r = cos(float(11-rad+1)/11*PI)#col.s = 1
#		#col.g = sin(float(11-rad+1)/11*PI)#col.h = fposmod(float(-.5-rad)/13,1)		
#		col.b = float(33)/255#1#col.r
		col.v = 1
		col.s = 1
		#col.h = float(172)/360
		#col.h = float(336)/360
		col.h = float(22)/360
	return col*gain