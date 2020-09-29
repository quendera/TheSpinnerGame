extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0,-global.stretch/2)
	color = global.hex_color(6,1)
	polygon = global.full_hex(global.poly_size/sqrt(3),1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
