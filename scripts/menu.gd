extends Node2D

var startLevel 
var hi_scores = [0,0,0,0]
var file = File.new()
var level = 0
var pass_scores = [100,200,600]
var player_name = ""

func _ready():
	if file.file_exists("user://hiscores"):
		file.open("user://hiscores",File.READ)
		for i in range(4):
			hi_scores[i] = int(file.get_line())
		file.close()
	$player_name.set_placeholder("Enter player name")
	if file.file_exists("user://playername"):
		file.open("user://playername",File.READ)
		player_name = file.get_line()
		if !player_name.empty():
			$player_name.set_text(player_name)
		file.close()
	var i = 0
	for button in get_tree().get_nodes_in_group("my_buttons"):
		button.connect("pressed", self, "_on_pressed",[i+3])
		i += 1
	update_buttons()
	
func _on_pressed(lev):
	level = lev
	startLevel = preload("res://scenes/game.tscn").instance()
	for button in get_tree().get_nodes_in_group("my_buttons"):
		button.hide()
	$player_name.hide()
	startLevel.init(lev,player_name)
	get_node("/root").add_child(startLevel)
	
func update_buttons():
	var i = 0
	for button in get_tree().get_nodes_in_group("my_buttons"):
		button.set_text("Level " + str(i+3) + " High: " + str(hi_scores[i]))
		button.set_disabled(i > 0 and hi_scores[i-1] < pass_scores[i-1])
		button.show()
		i += 1
	$player_name.show()
	
func _on_game_over():
	if global.score > hi_scores[level-3]:
		hi_scores[level-3] = global.score
	file.open("user://hiscores",File.WRITE)
	for i in range(4):
		file.store_string(str(hi_scores[i]) + "\n")
	file.close()
	startLevel.queue_free()
	update_buttons()
#
#func _on_player_name_text_changed( text ):
#	player_name = text # replace with function body


func _on_player_name_text_entered( text ):
	$player_name.release_focus()
	player_name = text # replace with function body
	file.open("user://playername",File.WRITE)
	file.store_string(player_name + "\n")
	file.close()