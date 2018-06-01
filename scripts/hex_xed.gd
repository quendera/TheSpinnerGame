extends Polygon2D

var coords = global.full_hex((global.poly_size*3*2+global.side_offset*2)/sqrt(3),1)
var mask = global.full_hex((global.poly_size*3*2)/sqrt(3))
var pie_coords = PoolVector2Array()
var how_far
var cur_bright

func _ready():
	position = Vector2(coords[0].x+global.h*global.padding/2,global.centre.y)
	pie_coords.insert(0,Vector2(0,0))
	pie_coords.append(coords[3])
	how_far = 0
	cur_bright = 0
	color = Color(cur_bright,cur_bright,cur_bright)
	
func _process(delta):
	cur_bright = cur_bright*(1-delta*5)
	cur_bright += delta*30*how_far*pow(randf()-.5,3)
	#cur_bright = min(1,max(.3,cur_bright)) 
	color = Color(cur_bright+.4,cur_bright+.4,cur_bright+.4) #global.hex_color(6#fmod(color.r+delta*how_far*randf(),1)#
	$"../hex_subwave".color = color
	$"../damage".set("custom_colors/font_color",color)

#func _draw():
#	draw_colored_polygon(polygon,Color(0,0,0))
#	if show_lines:
#		draw_line(Vector2(0,0),coords[3],Color(.5,.5,.5),10)
	#	draw_polyline(tracers,global.hint_color(6),5)

func set_shape(val):
	polygon = global.pie_hex(coords,val)
	cur_bright = 1
	how_far = min(val,1)
#	if val >= 1:
#		$"..".save_data()
#	if val >= 1:
#		polygon = coords
##		show_lines = false
#		update()
#		$"..".save_data()
#	elif val > 0:
#		#show_lines = $"../progress_tween".frac_fail != val
#		val = val*3
#		if pie_coords.size()/2 <= ceil(val - .001):
#			pie_coords.insert(1,Vector2(0,0))
#			pie_coords.insert(pie_coords.size(),Vector2(0,0))
#			pie_coords[2] = coords[3+floor(val)]
#			pie_coords[-2] = Vector2(pie_coords[2].x,-pie_coords[2].y)
#		pie_coords[1] = coords[fmod(3+ceil(val),6)]*fmod(val,1) + coords[3+floor(val)]*(1-fmod(val,1))
#		pie_coords[-1] = Vector2(pie_coords[1].x,-pie_coords[1].y)
#		polygon = pie_coords
##		tracers[0] = pie_coords[1]
##		tracers[2] = pie_coords[-1]
#		cur_bright = 1
##		update()