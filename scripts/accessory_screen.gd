extends Label

var acc_items = PoolStringArray(["",\
"We are neuroscientists who developed this game to study how humans learn to solve problems. By playing the game, people like you help make this possible!",\
"This game is a puzzle for you to solve. Keep on trying and leave the rest to your brain!",\
"",\
"design\nGautam Agarwal\nTiago Quendera\nZachary Mainen\n\nMusic\nAdapted from\n8notes.com\n\nlogo\ndiogo matias",\
"reach us at\nthehexxedgame@gmail.com\n\nIf you would like to disenroll from the study, please include code\n"])

func _ready():
		autowrap = true
		valign = VALIGN_CENTER
		align = ALIGN_CENTER
		add_to_group("menu_label")
		rect_size = Vector2(400,400)
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",global.hint_color(5))
		#rect_pivot_offset = rect_size/2.0 + Vector2(0,global.poly_size*5)
		rect_position = global.centre - rect_size/2.0# - rect_pivot_offset

func create(ind):
	text = acc_items[ind]
	if ind == 5:
		text = text + str($"../..".device_ID)
	#cur_rot = rot
	#rect_rotation = rot*60-180
