extends Label

func _ready():
	if global.curr_wv == 1:
		set_prc(0)
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",Color(0,0,0))
		rect_size = Vector2(global.w,global.h)
		rect_position = $"../hex_xed".position - rect_size/2
		show()
	else:
		hide()

func set_prc(val):
	if global.curr_wv == 1:
		text = str(round(val*100))+"%"

