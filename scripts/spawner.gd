extends Node2D

var ball_scene = preload("res://scenes/ball.tscn")
var ball_instance
var input_i = 0
var file = File.new()
export var arr = {}

#ON START:
func _ready():
	
	var i = 0
	file.open("res://assets/files/spawn.txt", File.READ)
	
	while (!file.eof_reached()):
		arr[i] = file.get_csv_line()
		i = i+1
	file.close() 

func _onready():
	self.set_position($game.center)


func spawn():
	ball_instance = ball_scene.instance()
	
	var input = arr
	var rot = input[input_i][0]
	var subwave = input[input_i][1]
	var wave = input[input_i][2]
	
	ball_instance.create(rot, subwave, wave, input_i)
	add_child(ball_instance)
	print("bu")
	
	input_i = input_i+1