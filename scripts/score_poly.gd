extends Polygon2D

#var total_outline
#var sw_outline

func _ready():
	position = Vector2(global.w*.2,global.h*.25)
	polygon = global.full_hex(global.poly_size*4)
	color = global.hint_color(8)
#	global.spiral_hex()
#	total_outline = global.progress_spiral #global.full_hex(global.progress_rad,1)
#	sw_outline = global.progress_spiral

#func _draw():
#	draw_polyline(global.full_hex(global.progress_rad*8,1),global.hint_color(1),2)

func set_shape(wave_age):
	if wave_age <= 0:
		wave_age = float(-wave_age)/6
#		$"../score_sw_poly".set_shape(wave_age,[0,
#		var sc = (1-(wave_age*float($"../Spawner".accum_points[$"../Spawner".sw]) + \
#			(1-wave_age)*float($"../Spawner".accum_points[$"../Spawner".sw+1]))/ \
#			$"../Spawner".accum_points[-1])
#		polygon = global.full_hex(global.progress_rad*8*sc)
		scale = Vector2(1,1)*(1-(wave_age*float($"../Spawner".accum_points[$"../Spawner".sw]) + \
			(1-wave_age)*float($"../Spawner".accum_points[$"../Spawner".sw+1]))/ \
			$"../Spawner".accum_points[-1])
#func _draw():
#	#rotation = -sw_outline[-1].angle() + PI/2
#	draw_polyline(sw_outline,global.which_color(12),5,1)
#	draw_polyline(total_outline,Color(.1,.1,.1),5,1)
	

#var start_grow = 0
#var grow_time = .3
#var score = 0
#var end_flag = 0
#var col = Color()
##var lab = Label.new()
#var scaled = 0
#var sw
#
#func _ready():
#	position = global.centre
#	set_scale(Vector2(0,0))
#	var coords = PoolVector2Array()
#	coords.resize(6)
#	for j in range(6):
#		coords[j] = Vector2(cos(j*PI/3)*global.poly_size,sin(j*PI/3)*global.poly_size)*2/sqrt(3)
#	set_polygon(coords)
#	add_to_group("score_poly")
#
#func create(sub):
#	sw = sub
#
#func _process(delta):
#	if end_flag == 1:
#		if global.dt > start_grow + grow_time*2:
#			position = get_tree().get_root().get_node("game").get_node("vis_score").centers[sw-1]
#			scale = Vector2(float(score+6)/12,float(score+6)/12)
#			#lab.set_text(String(global.sw_score))
#			#lab.set_global_position(position)
#			#lab.scale = 10 #Vector2(10,10)
#			#lab.show_on_top()
#			end_flag = 2
#			get_tree().get_root().get_node("game").get_node("Spawner").mySpawn()
#		elif global.dt <= start_grow + grow_time:
#			scaled = sin(PI/2*(global.dt - start_grow)/grow_time)*(score+6)/12
#			col = global.which_color(score+6)
#			#col.a = .1
#			self.set_color(col)
#			set_scale(Vector2(scaled,scaled)*12)
#		elif global.dt <= start_grow + grow_time*2 and global.dt >= start_grow + grow_time:
#			var frac = (global.dt - start_grow - grow_time)/(grow_time)
#			frac = sin(frac*PI/2)
#			set_scale(Vector2(scaled,scaled)*(12*(1-frac)+frac))
#			position = global.centre*(1-frac) + get_tree().get_root().get_node("game").get_node("vis_score").centers[sw-1]*frac
#
#func report(sub):
#	if sw == sub and end_flag == 0:
#		start_grow = global.dt
#		end_flag = 1
#		score = max(-5,global.sw_score)