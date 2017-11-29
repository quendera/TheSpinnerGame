extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	position = global.centre

func _draw():
	var coords = PoolVector2Array()
	coords.resize(7)
	for j in range(7):
		coords[j] = Vector2(cos(j*PI/3)*global.poly_size*6,sin(j*PI/3)*global.poly_size*6)*2/sqrt(3)
	self.draw_polyline_colors(coords,PoolColorArray([Color(1,1,1)]),5)
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
