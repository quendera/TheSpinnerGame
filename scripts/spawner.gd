extends Node2D

var file = File.new()
var input = {}

func _ready():
	self.set_position(get_tree().get_root().get_node("game").center)
	


func load_input():
	if file.open("res://assets/files/test.JSON", File.READ) != 0:
		print("Error reading file")
		return
		
	var newdict = {}
	
	while (!input.eof_reached()):
		input.parse_json(file.get_line())
		for i in input.keys():
			newdict[i] = i
			print(i)
		return newdict
	file.close() 