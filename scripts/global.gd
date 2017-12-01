extends Node

var w = 1280
var h = 720
var cx = w*.65#/2
var cy = h/2
var centre = Vector2(cx,cy)
var move_time_new = .15
var poly_size = w/44
var sw_count
var curr_wv
var sw_score
var score
var dt
var start_step
var save_file_name
var data
var sw_end_flag = 0

func _ready():
	pass
	
func which_color(rad):
	var col = Color()
#	col.r = 1-float(rad-1)/11#min(1,float(rad-1)/11*2)
#	col.g = col.r
#	col.b = float(rad-1)/11#min(1,2-float(rad-1)/11*2)
	if rad <= 6:
		col.r = float(rad)/6
		col.g = col.r
		col.b = col.r
	else: 
		col.r = min(1,float(rad-12)/5*2+2)
		col.g = min(1,float(12-rad)/5*2)
		#col.r = cos(float(11-rad+1)/11*PI)#col.s = 1
		#col.g = sin(float(11-rad+1)/11*PI)#col.h = fposmod(float(-.5-rad)/13,1)		
		col.b = 0#col.r
	return col