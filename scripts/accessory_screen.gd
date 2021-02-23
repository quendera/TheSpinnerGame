extends Label

var acc_items = PoolStringArray(["Many players find the game confusing at first. We give you no instructions because we are studying how you learn to make sense of the game. We hope you keep trying until you succeed!",\
"We are neuroscientists who developed this game to study how humans learn to solve problems. By playing the game, you provide the data to make this possible!\n\nYou can learn more at http://hexxed.io.\n\nYour user ID is\n",\
#"This game is a puzzle for you to solve. Keep on trying and leave the rest to your brain!",\
"",\
"",\
"Game Design\nGautam Agarwal + Tiago Quendera\n\nAdditional media\nBruna Pontes + Diogo Matias\n\nSpecial Thanks\nZachary Mainen + Mani Hamidi\n\nSound + Music\nfreesound.org + 8notes.com\n\nPowered by Godot Engine",\
""])
var http_request = HTTPRequest.new()
var leader_data = PoolIntArray()
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
	if ind == 0:
		leader_data = [OS.get_ticks_msec()]
	elif ind == 1:
		text = text + str($"../..".device_ID)
	elif ind == 2:
		leader_data = [OS.get_ticks_msec(),0,0,0,0] #start time,rank,players,server response time, server response
		#tot_stars = 0
		#for i in range(6):
		#	tot_stars = tot_stars + max(0,(i+1)*global.level_scores[i*2]/global.num_waves[i])
		#THE FOLLOWING IS WHERE I REQUEST RANK
		http_request.request(ip_url,["Content-Type: application/json", \
			str("ID:",$"../..".device_ID[0],"_",$"../..".device_ID[1])])#,true,HTTPClient.METHOD_GET)#POST,str(OS.get_datetime()))
		#write_data()
		leader_text("Accessing server...")
		#text = "RANK\nAccessing server\n\n" + "SCORE\n" + str(global.total_score) + \
		#"\n\nFor scoring rules visit hexxed.io"
		#text = You have unlocked\n" + str(tot_stars) + " out of 42\nblue hexxes."
	#cur_rot = rot
	#rect_rotation = rot*60-180

func write_help():
	var dict = OS.get_datetime()
	dict["start_time"] = leader_data[0]
	dict["screen_exit"] = OS.get_ticks_msec()
	var file = File.new()
	file.open("user://help" + String(OS.get_unix_time()) +".json", File.WRITE)
	file.store_line(to_json(dict))#OS.get_datetime()))
	file.close()
	$"../../../hex_root/data_send".search_and_send()

func write_data():
	var dict = OS.get_datetime()
	dict["start_time"] = leader_data[0]
	dict["current_score"] = global.total_score
	dict["rank"] = leader_data[1]
	dict["total_players"] = leader_data[2]
	dict["server_response_time"] = leader_data[3]
	dict["server_response"] = leader_data[4]
	dict["screen_exit"] = OS.get_ticks_msec()
	var file = File.new()
	file.open("user://lead" + String(OS.get_unix_time()) +".json", File.WRITE)
	file.store_line(to_json(dict))#OS.get_datetime()))
	file.close()
	$"../../../hex_root/data_send".search_and_send()

func _http_request_completed(result, response_code, headers, body):
	leader_data[3] = OS.get_ticks_msec()
	var response = body.get_string_from_utf8()
	var spl = response.split(",")
	if spl[0] == "ok":
		leader_data[4] = 1
		if spl[1] == "":
			leader_text("Play the game to get a rank!")
		else:
			leader_data[1] = int(spl[1])
			leader_data[2] = int(spl[3])
			leader_text(spl[1] + " of " + spl[3] + " players")
	else:
		leader_data[4] = -1
		leader_text("Could not access server")

func leader_text(rank):
	text = "RANK\n" + rank + "\n\n" + \
			"SCORE\n" + str(global.total_score) + \
			"\n\nFor scoring rules visit hexxed.io"
