extends Polygon2D

var point_num

func _ready():
	add_to_group("score_triangle")
	
func _process(delta):
	pass
	#var sc = min(1,max(0,global.dt/global.progress_draw_time
#	var sc = min(1,max(0,global.dt/global.progress_draw_time-float(point_num)/get_tree().get_root().get_node("game").get_node("Spawner").accum_points[-1]*global.progress_draw_time))
#	scale = Vector2(sc,sc)

func paint(start_ind,end_ind,status):
	if point_num > start_ind - 1 and point_num <= end_ind - 1:
		color.a = 1
		if status == 1:
			color = global.which_color(12).inverted()
		elif status == -1:
			color = global.which_color(12)
	#else:
	#	color.a = .2
			

func create(point_number): 
	point_num = point_number
	var rad = floor(sqrt(float(point_num)/6))
	var base = float(point_num + 1 - 6*pow(rad,2)+.5)/(2*rad+1)
	var weight = fposmod(base,1)
	base = float(floor(base))
	position = Vector2(global.w*.2,global.h*.33) #*-.134*pow(-1,fmod(point_num,2))*pow(-1,fmod(base+1,2))
	position += global.progress_rad*(rad+.5)*((1-weight)*Vector2(cos(base/3*PI),sin(base/3*PI)) + \
	weight*Vector2(cos((base+1)/3*PI),sin((base+1)/3*PI)))
	var offs = 4
	position += pow(-1,fmod(base+1,2))*global.progress_rad*(1-sqrt(3)/2)*pow(-1,fmod(point_num+1,2))*Vector2(sin((-base+offs)/3*PI),cos((-base+offs)/3*PI))
	var my_polygon = PoolVector2Array()
	my_polygon.resize(3)
	for i in range(3):
		my_polygon[i] = global.progress_rad/2*Vector2(sin(float(i)/3*2*PI),(cos(float(i)/3*2*PI))*pow(-1,fmod(point_num+1,2)))
	polygon = my_polygon
	color = Color(1,1,1,.2)