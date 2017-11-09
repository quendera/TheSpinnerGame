extends Node

var w = 1280
var h = 720
var cx = w/2
var cy = h/2
var centre = Vector2(cx,cy)
var vertices = PoolVector2Array([Vector2(0,40),Vector2(-34.6,20),Vector2(-34.6,-20),Vector2(0,-40),Vector2(34.6,-20),Vector2(34.6,20),Vector2(0,40)])
var score = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass