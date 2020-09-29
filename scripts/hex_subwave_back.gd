extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch))
	position = Vector2(global.scorebar_anchor-global.poly_size*2,global.h/2)
	color = global.hint_color(6)
