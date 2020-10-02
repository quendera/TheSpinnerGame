extends Label

var acc_items = PoolStringArray(["",\
"We are neuroscientists who developed this game to study how humans learn to solve problems. By playing the game, you provide the data to make this possible!",\
#"This game is a puzzle for you to solve. Keep on trying and leave the rest to your brain!",\
"",\
"",\
"Design\nGautam Agarwal\nTiago Quendera\nZachary Mainen\n\nMusic\nadapted from\n8notes.com\n\nAdditional media\nBruna Pontes\nDiogo Matias\n\nPowered by Godot Engine",\
"Reach us at\nthehexxedgame@gmail.com\n\nIf you would like to disenroll from the study, please include code\n"])
var http_request = HTTPRequest.new()
var tot_stars
var ip_url = "http://95.179.150.62" + "/upload/score.php"

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
		add_child(http_request)
		http_request.connect("request_completed", self, "_http_request_completed")

func create(ind):
	text = acc_items[ind]
	if ind == 5:
		text = text + str($"../..".device_ID)
	if ind == 2:
		tot_stars = 0
		for i in range(6):
			tot_stars = tot_stars + max(0,(i+1)*global.level_scores[i*2]/global.num_waves[i])
		#THE FOLLOWING IS WHERE I REQUEST RANK
		http_request.request(ip_url,["Content-Type: application/json", \
			str("ID:",$"../..".device_ID[0],"_",$"../..".device_ID[1])])
		text = "You have unlocked\n" + str(tot_stars) + " out of 42\nblue hexxes."
	#cur_rot = rot
	#rect_rotation = rot*60-180

func _http_request_completed(result, response_code, headers, body):
	var response = body.get_string_from_utf8()
	var spl = response.split(",")
	## THE FOLLOWING IS WHERE I PARSE THE MESSAGE TO GET RANK
	if spl[0] == "ok":
		if spl[1] == "":
			text = text + "\nYou need to play the game before you can be ranked!"
		elif spl[2] == "0":
			text = text + "\nYou need to complete a level before you can be ranked!"
		else:
			text = text + "\nYou are ranked\n" + spl[1] + " out of " + spl[3] + "\nplayers with a score of\n" + \
			str(global.total_score) + \
			".\nFor ranking rules visit hexxed.io"
	else:
		text = text + "\nTo see your global rank, please enable your data connection."
