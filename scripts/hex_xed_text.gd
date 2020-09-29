extends Label

func _ready():
	#set("custom_colors/font_color",global.hint_color(7))
	text = "DAMAGE"
	set("custom_fonts/font",global.fnt)
	rect_size = Vector2(global.h,global.h)
	rect_pivot_offset = rect_size/2
	rect_rotation = 270
	rect_position = - rect_size/2
