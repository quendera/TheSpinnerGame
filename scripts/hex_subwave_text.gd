extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "POINTS"
	set("custom_colors/font_color",global.hint_color(7))
	set("custom_fonts/font",global.fnt)
	rect_size = Vector2(global.h,global.h)
	rect_pivot_offset = rect_size/2
	rect_rotation = 270
	rect_position = - rect_size/2
	if global.scorebar_mode == 0:
		hide()
