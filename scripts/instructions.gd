extends Label

func _ready():
	if global.curr_wv == 1:
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",global.hint_color(7))
		rect_size = Vector2(global.h,global.h)
		rect_pivot_offset = rect_size/2
		if global.scorebar_mode == 0:
			text = "TAP TO ADVANCE\nSWIPE TO COLLECT" #"TAP AND SWIPE"
			rect_position = Vector2(global.w/5,global.h*.82) - rect_size/2
		else:
			text = "CONTROLS: TAP AND SWIPE"
			rect_rotation = 270
			rect_position = Vector2(global.scorebar_anchor+global.poly_size*6,global.h/2) - rect_size/2
		show()
	else:
		hide()
