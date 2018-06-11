extends Label

func _ready():
	if global.curr_wv == 1:
		set_prc(0)
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",global.hint_color(7))
		rect_size = Vector2(global.w,global.h)
		rect_position = $"../hex_xed".position - rect_size/2
		#show()
	else:
		hide()

func set_prc(val):
	if global.curr_wv == 1:
		text = str(val)+"%"