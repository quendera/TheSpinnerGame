extends HTTPRequest

var dir = Directory.new()
var file_name
var ip_url = "http://95.179.150.62" + "/upload/gd.php"
var header
var query
var file = File.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = 1
	use_threads = true
	connect("request_completed",self,"_on_request_completed")
	dir.open("user://")
	#search_and_send()
	#add_to_group("file_to_send")

func search_and_send():
	cancel_request()
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		if file_name.begins_with("data"):
			file.open("user://" + file_name,file.READ)
			header = ["Content-Type: application/json", \
			str("ID:",$"..".device_ID[0],"_",$"..".device_ID[1]) , \
			str("SESSIONID:",file_name.left(file_name.length()-5).right(4))]
			request(ip_url, header,true,HTTPClient.METHOD_POST,file.get_as_text())
			#data_send_instance.create(file_name.left(file_name.length()-5).right(4),device_ID,file1.get_as_text())
			file.close()
			break
		else:
			file_name = dir.get_next()
	dir.list_dir_end()

#func create(fname,devID,quer):
#	finame = fname
#	header = ["Content-Type: application/json", str("ID:",devID[0],"_",devID[1]) , str("SESSIONID:",fname)]
#	query = quer
	
#func request_wrapper():
#	print(finame)
#	request(ip_url, header,true,HTTPClient.METHOD_POST,query)
	#connect("request_completed",self,"_on_data_send_request_completed",[fname])
	
func _on_request_completed(_result, _response_code, _headers, body):
#	print(3)
	print(body.get_string_from_utf8())
	print(file_name)
	if body.get_string_from_utf8() == "upload successful":
		dir.remove(file_name)#"user://data" + finame + ".json")
		search_and_send()
		#queue_free()
