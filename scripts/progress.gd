extends Label

func _ready():
	if global.curr_wv == 1:
		set("custom_colors/font_color",global.hex_color(6))
		rect_scale = global.h/720.0*Vector2(1,1)
		rect_size = Vector2(global.w,global.h)#/3
		rect_pivot_offset = Vector2(rect_size.x,0)
		rect_position = $"../hex_progress".coords[0] + $"../hex_progress".position -  Vector2(rect_size.x,0) + Vector2(2,-5)# - Vector2(rect_size.x,rect_size.y)
		rect_rotation = 60
		show()
	else:
		hide()