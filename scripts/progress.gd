extends Label

var coords = global.full_hex((global.poly_size*3*2)/sqrt(3),1)

func _ready():
	if global.curr_wv == 1 and global.scorebar_mode == 0:
		set("custom_colors/font_color",global.hex_color(6))
		#rect_scale = Vector2(1,1)
		#rect_size = Vector2(global.w,global.h)#/3
		#rect_pivot_offset = Vector2(rect_size.x,0)
		#if global.scorebar_mode == 0:
		rect_position = coords[0] + $"../hex_xed".position # -  Vector2(rect_size.x,0) + Vector2(2,-5)# - Vector2(rect_size.x,rect_size.y)
		#rect_rotation = 60 + 180
		show()
	else:
		hide()
