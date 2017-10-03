extends Node2D


func _onready():
	var tr = PoolVector2Array([[1,2],[1,2]])

func _ready():

	$tween.interpolate_property(self, "position", Vector2(self.position.x,self.position.y), Vector2(0,100), 0.5, $tween.TRANS_LINEAR, $tween.EASE_IN)
	$tween.start()

func go():
	print(get_node("../ball").vertices[1][1])
