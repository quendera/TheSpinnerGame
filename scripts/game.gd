extends Node2D

#DEFINE VARS:
var dt=0
var center=Vector2(960,540)
var w = get_viewport_rect().size.y
var h = get_viewport_rect().size.x

#ON START:
func _ready():
	set_process(true)


#EVERY FRAME(DT):
func _process(delta):
	dt = dt + delta



