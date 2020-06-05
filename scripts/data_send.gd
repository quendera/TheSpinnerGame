extends HTTPRequest

var dir = Directory.new()
var finame
var ip_url = "http://95.179.150.62" + "/upload/gd.php"
var header
var query

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = 1
	use_threads = true
	connect("request_completed",self,"_on_request_completed")
	add_to_group("file_to_send")
	
func create(fname,devID,quer):
	finame = fname
	header = ["Content-Type: application/json", str("ID:",devID[0],"_",devID[1]) , str("SESSIONID:",fname)]
	query = quer
	
func request_wrapper():
	request(ip_url, header,true,HTTPClient.METHOD_POST,query)
	#connect("request_completed",self,"_on_data_send_request_completed",[fname])
	
func _on_request_completed(_result, _response_code, _headers, body):
	if body.get_string_from_utf8() == "upload successful":
		dir.remove("user://data" + finame + ".json")
		queue_free()
