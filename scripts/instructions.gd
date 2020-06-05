extends Label

func _ready():
	if global.curr_wv == 1:
		text = "TAP TO ADVANCE\nSWIPE TO COLLECT" #"TAP AND SWIPE"
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",global.hint_color(7))
		rect_size = Vector2(global.h,global.h)
		rect_pivot_offset = rect_size/2
		#rect_scale = Vector2(.7,.7)
		#align = ALIGN_LEFT
		#rect_rotation = 270
		#Vector2(global.w*.05,global.h/2)- rect_size/2#
		rect_position = Vector2(global.w/5,global.h*.82) - rect_size/2
		show()
	else:
		hide()
