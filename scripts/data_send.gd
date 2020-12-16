extends HTTPRequest

var dir = Directory.new()
var file_name
var ip_url = "http://95.179.150.62/upload/"# + "/upload/gd.php"
var suff = ["gd.php","survey.php","leaderboard.php"]
var header
var query
var file = File.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = 3
	use_threads = true
	connect("request_completed",self,"_on_request_completed")
	dir.open("user://")

func search_and_send():
	cancel_request()
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		if file_name.begins_with("data") or file_name.begins_with("surv") or file_name.begins_with("lead"):
			file.open("user://" + file_name,file.READ)
			header = ["Content-Type: application/json", \
			str("ID:",$"..".device_ID[0],"_",$"..".device_ID[1]) , \
			str("SESSIONID:",file_name.left(file_name.length()-5).right(4)), \
			str("SCORE:",global.total_score)]
			var ind
			if file_name.begins_with("data"):
				ind = 0
			elif file_name.begins_with("surv"):
				ind = 1
			else:
				ind = 2
			request(ip_url + suff[ind], header,true,HTTPClient.METHOD_POST,file.get_as_text())
			#data_send_instance.create(file_name.left(file_name.length()-5).right(4),device_ID,file1.get_as_text())
			file.close()
			break
		else:
			file_name = dir.get_next()
	dir.list_dir_end()

func _on_request_completed(_result, _response_code, _headers, body):
	#print(body.get_string_from_utf8())
	if body.get_string_from_utf8() == "upload successful":
		dir.remove(file_name)#"user://data" + finame + ".json")
		search_and_send()
		#queue_free()
