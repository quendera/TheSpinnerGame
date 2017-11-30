extends Node

var w = 1280
var h = 720
var cx = w/2
var cy = h/2
var centre = Vector2(cx,cy)
var move_time = .05
var poly_size = cx/22
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
	if rad <= 6:
		col.r = float(rad)/6
		col.g = col.r
		col.b = col.r
	else: 
		col.b = 0
		col.r = min(1,float(rad-12)/5*2+2)
		col.g = min(1,float(12-rad)/5*2)
#		col.r = cos(float(12-rad)/5*PI/2)#col.s = 1
#		col.g = sin(float(12-rad)/5*PI/2)#col.h = fposmod(float(-.5-rad)/13,1)
	return col