extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	position = Vector2(global.w*.2,global.h*.25)
#	polygon = global.full_hex(global.progress_rad*8)
	color = global.hint_color(6)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
