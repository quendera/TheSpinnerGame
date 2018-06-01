extends Label

var cur_rot
var max_scale = Vector2(1,1)

func _ready():
		valign = VALIGN_CENTER
		align = ALIGN_CENTER
		add_to_group("menu_label")
		rect_size = Vector2(400,400)
		rect_scale = 0*max_scale
		rect_pivot_offset = rect_size/2.0 + Vector2(0,global.poly_size*5)
		rect_position = global.centre - rect_pivot_offset

func create(rot,txt):
	text = txt
	cur_rot = rot
	rect_rotation = rot*60-180
	set("custom_fonts/font",global.fnt)
	set("custom_colors/font_color",global.hint_color(7))
	
func set_shape(val):
	if val <= 0:
		modulate = Color(1,1,1,1)
		rect_scale = max_scale*(6+val)/6.0
	else:#if cur_rot != lobe:
		modulate = Color(1,1,1,1-val)