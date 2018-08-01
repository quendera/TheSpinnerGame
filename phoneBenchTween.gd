extends Tween

var notesT = PoolVector2Array()
var notesB = PoolVector2Array()
var measure_time = 9 # 5
var game_measure = 1.8 #2.5
var drone_measure = 2.4 #5
var move_time_new = .3
var play_state = Vector3(0,0,0)
var file = File.new()

func _ready():
	playback_process_mode = TWEEN_PROCESS_PHYSICS
	read_music_time()
	AudioServer.set_bus_volume_db(4,-30)
	AudioServer.set_bus_volume_db(6,-30)
	AudioServer.set_bus_volume_db(1,-20)
	AudioServer.set_bus_volume_db(5,-20)
	drone_timer(0,0,0)
	start()
	
func read_music_time():#fname):
	file.open("res://assets/files/jesu.txt", File.READ)
	var target_line
	while !file.eof_reached():
		target_line = file.get_csv_line()
		if target_line.size() == 4:
			if int(target_line[3]) == 1:
				notesT.push_back(Vector2(int(target_line[0]),float(target_line[1])))
			else:
				notesB.push_back(Vector2(int(target_line[0]),float(target_line[1])))
	file.close()


func drone_timer(counter,indT,indB):
	if notesT[indT].y == counter:
		#AudioServer.get_bus_effect(4,0).pitch_scale = pow(2,notesT[indT].x/12.0-5-1)
		$"../drone".pitch_scale = pow(2,notesT[indT].x/12.0-5-1)
		$"../drone".play()
		indT += 1
	if notesB[indB].y == counter:
		#AudioServer.get_bus_effect(6,0).pitch_scale = pow(2,notesB[indB].x/12.0-5-1)
		$"../droneB".pitch_scale = pow(2,notesB[indB].x/12.0-5-1)
		$"../droneB".play()
		indB += 1
	counter += 1
	if counter >= play_state.z*measure_time:
		interpolate_callback(self,move_time_new + 12*move_time_new,"drone_timer",0,0,0)
	else:
		interpolate_callback(self,move_time_new,"drone_timer",counter,indT,indB)
		
func timed_play():
	var st_t
	var start_time = 0
	while play_state.x < notesB.size() and notesB[play_state.x].y < (play_state.z+1)*measure_time:
		st_t = start_time+ (notesB[play_state.x].y - play_state.z*measure_time)/measure_time*game_measure
		interpolate_callback(self,st_t,"play_timed_midiB",notesB[play_state.x].x)
		play_state.x += 1
	while play_state.y < notesT.size() and notesT[play_state.y].y < (play_state.z+1)*measure_time:
		st_t = start_time+ (notesT[play_state.y].y - play_state.z*measure_time)/measure_time*game_measure
		interpolate_callback(self,st_t,"play_timed_midi",notesT[play_state.y].x)
		play_state.y += 1
	play_state.z += 1

func play_timed_midi(pitch):
	#AudioServer.get_bus_effect(1,0).pitch_scale = pow(2,pitch/12.0-5-1)
	$"../spiccato".pitch_scale = pow(2,pitch/12.0-5-1)
	$"../spiccato".play()

func play_timed_midiB(pitch):
	#AudioServer.get_bus_effect(5,0).pitch_scale = pow(2,pitch/12.0-5-1)
	$"../spiccatoB".pitch_scale = pow(2,pitch/12.0-5-1)
	$"../spiccatoB".play()