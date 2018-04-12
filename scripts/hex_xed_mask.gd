extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	polygon = global.full_hex((global.poly_size*3*2)/sqrt(3))
	color = Color(0,0,0)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
