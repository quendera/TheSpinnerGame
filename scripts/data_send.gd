extends HTTPRequest

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

#func send_data(QUERY):
#	var HEADERS = ["Content-Type: application/json", str("ID:",device_ID[0],"_",device_ID[1]) , str("SESSIONID:",OS.get_unix_time())]
#	request(url, HEADERS,true,HTTPClient.METHOD_POST,QUERY)
	#request ( bool ssl_validate_domain=true, int method=0, String request_data=”” )

func send_data_from_directory():
	#var files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	var file = File.new()
	while true:
		var filename = dir.get_next()
		if filename == "":
			break
		elif filename.begins_with("data"):
			file.open("user://" + filename,file.READ)
			if send_data(file.get_as_text()) == HTTPClient.STATUS_BODY:
				dir.remove(filename)
			else:
				file.close()
				break
			#print( file.get_as_text())
			file.close()
			#break
            #files.append(file)
	dir.list_dir_end()