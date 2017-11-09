extends Node2D

var ball_scene = preload("res://scenes/ball.tscn")
var ball_instance
var input_i = 0
var file = File.new()
export var arr = {}
var prev_sw = 0
var rand_rot = 0
var send_rot = 0
var next_sw = 0
var sw = 1
var next_wv = 0
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
	var subwave = input[input_i][2]
	var wave = int(input[input_i][1])
	
	if input_i > 0:
		prev_sw = int(input[input_i-1][2])
		next_sw = int(input[input_i+1][2])
		next_wv = int(input[input_i+1][1])
	
	sw = int(subwave)
	
	if sw > prev_sw or wave < next_wv:
		rand_rot = randi() % 6
	
	
	send_rot = int(rot) #+rand_rot
	
	ball_instance.create(send_rot, subwave, wave, input_i)
	add_child(ball_instance)
	
	input_i = input_i+1
	
	if sw == next_sw:
		self.spawn()
	
