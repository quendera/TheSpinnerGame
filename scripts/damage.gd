extends Label

func _ready():
	if global.curr_wv == 1 and global.scorebar_mode == 0:
		set("custom_colors/font_color",global.hint_color(7))
		#rect_scale = Vector2(1,1)
		#rect_size = Vector2(global.w,global.h)#/10
		#rect_pivot_offset = Vector2(rect_size.x,0)
		rect_position = $"../hex_xed".coords[0] + $"../hex_xed".position# - Vector2(rect_size.x,0) + Vector2(2,-5)
		#rect_rotation = 60 + 180
		show()
	else:
		hide()
