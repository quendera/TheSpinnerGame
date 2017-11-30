extends Polygon2D

var start_grow = 0
var grow_time = .5
var score = 0
var end_flag = 0
var col = Color()

func _ready():
	position = global.centre
	set_scale(Vector2(0,0))
	var coords = PoolVector2Array()
	coords.resize(6)
	for j in range(6):
		coords[j] = Vector2(cos(j*PI/3)*global.poly_size,sin(j*PI/3)*global.poly_size)*2/sqrt(3)
	set_polygon(coords)
	
func _process(delta):
	if global.dt > start_grow + grow_time and global.sw_end_flag:
		global.sw_end_flag = 0
		set_scale(Vector2(0,0))
		get_tree().get_root().get_node("game").get_node("Spawner").mySpawn()
	elif global.dt <= start_grow + grow_time and global.sw_end_flag:
		var sc = min(1,(global.dt - start_grow)/grow_time*2)*(score+6)/12
		var scc = float(score+6)
		col = global.which_color(scc)
		self.set_color(col)
		set_scale(Vector2(sc,sc)*12)
	
func report(sc):
	start_grow = global.dt
	global.sw_end_flag = 1
	score = max(-5,sc)