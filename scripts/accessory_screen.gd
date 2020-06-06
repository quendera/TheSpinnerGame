extends Label

var acc_items = PoolStringArray(["",\
"We are neuroscientists who developed this game to study how humans learn to solve problems. By playing the game, you provide the data to make this possible!",\
"This game is a puzzle for you to solve. Keep on trying and leave the rest to your brain!",\
"",\
"Design\nGautam Agarwal\nTiago Quendera\nZachary Mainen\n\nMusic\nadapted from\n8notes.com\n\nAdditional media\nBruna Pontes\nDiogo Matias\n\nPowered by Godot Engine",\
"Reach us at\nthehexxedgame@gmail.com\n\nIf you would like to disenroll from the study, please include code\n"])

func _ready():
		autowrap = true
		valign = VALIGN_CENTER
		align = ALIGN_CENTER
		#add_to_group("menu_label")
		rect_size = Vector2(global.h*.9,global.w)#400,400)
		set("custom_fonts/font",global.fnt)
		set("custom_colors/font_color",global.hint_color(5))
		#rect_pivot_offset = rect_size/2.0 + Vector2(0,global.poly_size*5)
		rect_position = Vector2(global.w*3/5,global.h/2) - rect_size/2.0# - rect_pivot_offset
		rect_pivot_offset = rect_size/2
		rect_rotation = 270

func create(ind):
	text = acc_items[ind]
	if ind == 5:
		text = text + str($"../..".device_ID)
	#cur_rot = rot
	#rect_rotation = rot*60-180
