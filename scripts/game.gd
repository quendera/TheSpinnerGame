extends Node2D

#DEFINE VARS:
var dt = 0

#ON START:
func _ready():
	set_process(true)

#EVERY FRAME(DT):
func _process(delta):
	dt = dt + delta
	$Label.set_text("Score: "+ str(global.score))

func go(side):
	get_tree().call_group("balls", "step")
	
	var get_len = get_tree().get_nodes_in_group("balls").size()
	if  get_len == 0:
		$Spawner.spawn()