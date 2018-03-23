extends Node

var w = 1280
var h = 720
var padding = .15
var centre = Vector2(w-h/sqrt(3),h*.5)
var move_time_new = 1.0/4
var offset_poly_ratio = .3
var poly_size = ((1-padding)*h)/2/(6+offset_poly_ratio)#w/50
var side_offset = poly_size*offset_poly_ratio
var sw_count
var curr_wv
var total_time
var sw_score
var score
var dt
var save_file_name
var data

func full_hex(radius,wire =0):
	var coords = PoolVector2Array()
	for i in range(6+wire):
		coords.append(Vector2(cos(float(i)/3*PI),sin(float(i)/3*PI))*radius)
	return coords

func hex_color(rad,invert=false,dim = 1):
	var col = Color()
	col.v = float(rad+2)/(6+2)
	col.s = 1
	col.h = 22.0/360
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

#func pie_hex(full,angle):
#	var coords = PoolVector2Array(full)
#	coords.insert(0,Vector2(0,0))
#	coords.resize(ceil(angle)+2)
#	angle = fmod(angle,1)
#	if angle > 0:
#		coords[coords.size()-1] = full[coords.size()-2]*angle+full[coords.size()-3]*(1-angle)
#	return coords

#var progress_loops = 10
#var progress_rad = poly_size#/10.0*8 #20/sqrt(accum_points[-1])
#var side_offset = float(progress_rad)
#var progress_spiral = PoolVector2Array()
#var progress_frac = Array()
#var progress_draw_time = 1
#var start_step
#var sw_end_flag = 0