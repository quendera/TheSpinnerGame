extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "MAX"
	set("custom_colors/font_color",global.hex_color(6,1))
	set("custom_fonts/font",global.fnt)
	set("custom_fonts/font/size",10)
	rect_size = Vector2(global.h,global.h)
	rect_pivot_offset = rect_size/2
	rect_rotation = 270
	rect_position = - rect_size/2 + Vector2(0,-global.stretch/2)
	if global.scorebar_mode == 0:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
