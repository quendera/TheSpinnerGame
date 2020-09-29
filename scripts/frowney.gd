extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#modulate = global.hint_color(18)
	scale = Vector2(.04,.04)
	position = Vector2(0,-global.stretch/2)
