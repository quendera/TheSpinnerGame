extends Polygon2D

var rad
var rot_int
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _init(a,b):
	rad = a
	rot_int = b

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	add_to_group("poly_panel")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
