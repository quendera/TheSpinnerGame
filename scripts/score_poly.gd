extends Polygon2D

var start_grow = 0
var grow_time = .3
var score = 0
var end_flag = 0
var col = Color()
var scaled = 0
var sw

func _ready():
	position = global.centre
	set_scale(Vector2(0,0))
	var coords = PoolVector2Array()
	coords.resize(6)
	for j in range(6):
		coords[j] = Vector2(cos(j*PI/3)*global.poly_size,sin(j*PI/3)*global.poly_size)*2/sqrt(3)
	set_polygon(coords)
	add_to_group("score_poly")
	
func create(sub):
	sw = sub
	
func _process(delta):
	if end_flag == 1: #global.sw_
		if global.dt > start_grow + grow_time*2:
			position = get_tree().get_root().get_node("game").get_node("vis_score").centers[sw-1]
			scale = Vector2(float(score+6)/12,float(score+6)/12)
			end_flag = 2 #global.sw_
			get_tree().get_root().get_node("game").get_node("Spawner").mySpawn()
		elif global.dt <= start_grow + grow_time:
			#scaled = (1-cos(PI*(global.dt - start_grow)/grow_time[0]))/2*(score+6)/12
			scaled = sin(PI/2*(global.dt - start_grow)/grow_time)*(score+6)/12
			col = global.which_color(score+6)
			self.set_color(col)
			set_scale(Vector2(scaled,scaled)*12)
		elif global.dt <= start_grow + grow_time*2 and global.dt >= start_grow + grow_time:
			var frac = (global.dt - start_grow - grow_time)/(grow_time)
			frac = sin(frac*PI/2)#(1-cos(frac*PI))/2
			set_scale(Vector2(scaled,scaled)*(12*(1-frac)+frac))
			position = global.centre*(1-frac) + get_tree().get_root().get_node("game").get_node("vis_score").centers[sw-1]*frac
	
func report(sub):
	if sw == sub and end_flag == 0:
		start_grow = global.dt
		end_flag = 1
		score = max(-5,global.sw_score)