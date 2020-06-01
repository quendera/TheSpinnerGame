extends Label

func _ready():
	if global.curr_wv == 1:
		text = "TAP TO ADVANCE\nSWIPE TO COLLECT" #"TAP AND SWIPE"
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",global.hint_color(7))
		rect_size = Vector2(global.w,global.h)
		rect_position = Vector2(global.w/5,global.h*.82) - rect_size/2
		show()
	else:
		hide()
