extends Node2D

var idx

func _onready():
	
	var tr = PoolVector2Array([[1,2],[1,2]])
	
func _ready():
	self.position.x = global.cx
	self.position.y = global.cy
	#$tween.interpolate_property(self, "position", Vector2(self.position.x,self.position.y), Vector2(0,100), 0.5, $tween.TRANS_LINEAR, $tween.EASE_IN)
	#$tween.start()
	print("ya")
	self.set_scale(Vector2(0,0))
	add_to_group("balls")

func create(rot, subwave, wave, ball_id):
	idx = ball_id
	#print(rot)
	#print(subwave)
	#print(wave)

func step():
	var size = 1