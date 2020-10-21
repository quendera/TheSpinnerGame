extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	polygon = global.full_hex(global.poly_size*.66)
	color = global.hex_color(6)#Color(1,1,1)*.7

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
