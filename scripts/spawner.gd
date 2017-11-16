extends Node2D

var ball_scene = preload("res://scenes/ball.tscn")
var ball_instance
var input_i #= 0
var file = File.new()
export var arr = {}
var sw = 0
var curr_wv = 3
var rand_seq
var ball_per_sw
var sw_order

#ON START:
func _ready():
	var i = 0
	file.open("res://assets/files/spawn.txt", File.READ)
	while (!file.eof_reached()):
		var target_line = file.get_csv_line()
		if target_line.size() == 3 and int(target_line[1]) == curr_wv:
			arr[i] = target_line
			i = i+1
	ball_per_sw = int(arr[arr.size()-1][2])
	sw_order = shuffleList(range(ball_per_sw))
	ball_per_sw = arr.size()/ball_per_sw
	file.close() 

func _onready():
	self.set_position($game.center)

func shuffleList(list):
    var shuffledList = [] 
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func mySpawn():
	var rand_offset = randi() % 6
	var rand_flip = randi() % 2
	var counter = 0
	global.start_step = 0
	for i in range(ball_per_sw): #while input_i < arr.size() and int(arr[input_i][2]) == sw:
		input_i = sw_order[sw]*ball_per_sw + i
		ball_instance = ball_scene.instance()
		var send_rot = (int(arr[input_i][0])+rand_offset)%6 #+rand_rot
		if rand_flip:
			send_rot = 5-send_rot
		ball_instance.create(send_rot, sw, curr_wv, input_i)
		add_child(ball_instance)
		#input_i += 1
		counter += 1
		get_tree().call_group("balls", "step")
	sw += 1
	while counter < 6:
		counter += 1
		get_tree().call_group("balls", "step")