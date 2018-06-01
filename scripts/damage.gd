extends Label

func _ready():
	if global.curr_wv == 1:
		set("custom_colors/font_color",global.hint_color(7))
		rect_size = Vector2(global.w,global.h)#/10
		rect_pivot_offset = Vector2(rect_size.x,0)
		rect_position = $"../hex_xed".coords[0] + $"../hex_xed".position - Vector2(rect_size.x,0)+ Vector2(2,-5)#Vector2(global.w/4.0,global.h*4.2/5.0)# - rect_size/2
		rect_rotation = 60
		show()
	else:
		hide()