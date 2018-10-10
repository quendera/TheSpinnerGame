extends Tween

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func drone_timer(counter,indT,indB):
	if counter == 0:
		global.data["drone_play"].push_back(OS.get_ticks_msec())
	if $"../Spawner".notesT[indT].y == counter:
		$"../progress_tween".play_timed_midi($"../Spawner".notesT[indT].x,$"../drone")
		indT += 1
	if $"../Spawner".notesB[indB].y == counter:
		$"../progress_tween".play_timed_midi($"../Spawner".notesB[indB].x,$"../droneB",1)
		indB += 1
	counter += 1
	if counter >= $"../progress_tween".play_state.z*global.measure_time:
		indT = 0
		indB = 0
		interpolate_callback(self,global.move_time_new + 12*global.move_time_new,"drone_timer",0,indT,indB)
	else:
		interpolate_callback(self,global.move_time_new/round(global.measure_time/8),"drone_timer",counter,indT,indB) #global.drone_measure/global.measure_time
	start()