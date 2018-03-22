extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	position = $"../hex_progress".position
	polygon =  $"../hex_progress".polygon
	color = global.hex_color(6,0,.7)
	scale = Vector2(1,1)*0
