extends Node2D

var circScale = 9*40
var w = 1280
var h = 720
var cx = w/2
var cy = h/2
var cirCol = Color(.5,.5,.5)
var lineCol = Color(1,1,1)

func _ready():
	pass

func _draw():
	self.draw_circle(Vector2(cx,cy),circScale,cirCol)
	self.draw_circle(Vector2(cx,cy),circScale/2,cirCol/2)
	for i in range(0,3):
		var offsetY = cos(i*PI/3)*circScale
		var offsetX = sin(i*PI/3)*circScale
		self.draw_line(Vector2(cx-offsetX,cy-offsetY),Vector2(cx+offsetX,cy+offsetY),lineCol,2)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
