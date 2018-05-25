extends Label

var cur_rot
var max_scale = Vector2(1,1)

func _ready():
		valign = VALIGN_CENTER
		align = ALIGN_CENTER
		add_to_group("menu_label")
		rect_size = Vector2(400,400)
		rect_scale = 0*max_scale#Vector2(3,3)
		rect_pivot_offset = rect_size/2.0 + Vector2(0,global.poly_size*5)#/lbl.rect_scale.x
		rect_position = global.centre - rect_pivot_offset#/lbl.rect_scale.x
		#add_font_override("font", load("res://assets/batmfa__.ttf"))
		#var fn = load("res://assets/batmfa__.ttf")
		#set("custom_fonts/font", global.batman)#load("res://assets/batmfa__.ttf")) #from https://www.dafont.com batmanforever techno

func create(rot,txt,fnt):
	text = txt
	cur_rot = rot
	rect_rotation = rot*60-180
	set("custom_fonts/font",fnt)
	
func set_shape(val):
	if val <= 0:
		modulate = Color(1,1,1,1)
		rect_scale = max_scale*(6+val)/6.0
	else:#if cur_rot != lobe:
		modulate = Color(1,1,1,1-val)