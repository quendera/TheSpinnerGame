extends Node2D

#DEFINE VARS:
var dt = 0

#ON START:
func _ready():
	set_process(true)

#EVERY FRAME(DT):
func _process(delta):
	dt = dt + delta
	

func go(side):
	get_tree().call_group("balls", "step")
	$Spawner.spawn()
	#print(side)