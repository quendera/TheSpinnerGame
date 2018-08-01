extends Node2D

var hex_instance
var num_hex = 1
var num_sides = 6
var poly_size = 100
var accum = 0
var cols = PoolColorArray()

func _ready():
	cols.resize(6)
	for i in range(6):
		cols[i] = Color(sin(i*PI/3)/2+.5,cos(i*PI/3)/2+.5,1,.3)
	for i in range(num_hex):
		make_hex(Vector2(global.w/2,global.h/2))
#	for i in range(num_hex):
#		hex_instance = Polygon2D.new()
#		hex_instance.polygon = global.full_hex(40)
#		hex_instance.position = Vector2(i*global.w/num_hex,global.h/2.0)
#		hex_instance.vertex_colors = cols
##		hex_instance.color = Color(1,1,1,.3)
#		hex_instance.add_to_group("hexxes")
#		add_child(hex_instance)

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			make_hex(event.position)

func _process(delta):
	accum += delta
	#hex_instance.rotate(delta*2)
	#hex_instance.translate(Vector2(0,cos(accum)))
	#get_tree().call_group("hexxes","hide")
	get_tree().call_group("hexxes", "rotate", delta*2)
	get_tree().call_group("hexxes", "translate",Vector2(0,cos(accum)))
#	draw_colored_polygon(global.full_hex(global.poly_size/2,0,Vector2(i*global.w + pow(-1,i)*global.poly_size,j*global.h + pow(-1,j)*global.poly_size*sqrt(3)/2)),Color(1,0,0))

func make_hex(pos):
	hex_instance = Polygon2D.new()
	hex_instance.polygon = bench_shape(num_sides,poly_size)
	hex_instance.position = pos#Vector2(randf()*global.w,randf()*global.h)
	hex_instance.vertex_colors = cols
	add_child(hex_instance)
	hex_instance.add_to_group("hexxes")
	$phoneBenchTween.timed_play()
	
func bench_shape(sides,radius):
	var coords = PoolVector2Array()
	for i in range(sides):
		coords.append(Vector2(cos(float(i)/sides*2*PI),sin(float(i)/sides*2*PI))*radius)
	return coords