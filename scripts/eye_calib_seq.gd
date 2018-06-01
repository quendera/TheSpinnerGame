extends Node

var text = PoolStringArray(["Point your nose to the 'X'\nwhile following the  .\nwith your eyes.","Ready","3","2","1","X"])
var text_times = PoolIntArray([10,1,1,1,1,0])
var target_time = 3
var lbl = Label.new()
var twn = Tween.new()
var hex = global.full_hex((global.poly_size*6*2+global.side_offset)/sqrt(3),1)
var target = Polygon2D.new()

func _ready():
	add_child(twn)
	add_child(lbl)
	lbl.valign = Label.VALIGN_CENTER
	lbl.align = Label.ALIGN_CENTER
	lbl.rect_size = Vector2(global.w,global.h)
	lbl.rect_position = Vector2(global.w,global.h)/2 - lbl.rect_size/2
	lbl.set("custom_fonts/font",global.fnt)
	lbl.set("custom_colors/font_color",global.hint_color(7))
	target.polygon = global.full_hex(global.poly_size/2)
	target.color = Color(0,1,0)
	target.position = global.centre
	target.offset = Vector2(80,0)
	twn.interpolate_callback(target,text_times[0],"hide")
	add_child(target)
	var start_time = 0
	for i in range(text.size()):
		twn.interpolate_callback(lbl,start_time,"set","text",text[i])
		start_time += text_times[i]
	for i in range(3):
		twn.interpolate_callback(lbl,start_time,"set","rect_position",global.centre - lbl.rect_size/2 + hex[i*2])
		start_time += target_time
		twn.interpolate_callback(target,start_time,"show")
		for j in range(6):
			twn.interpolate_callback(target,start_time,"set","offset",(hex[j]+hex[j+1])/2)
			start_time += target_time
		twn.interpolate_callback(target,start_time,"hide")
	twn.interpolate_callback(self,start_time,"queue_free")
	twn.interpolate_callback($"..",start_time,"new_menu")
	twn.start()
	var file = File.new()
	file.open("user://calibration_start" + str(OS.get_unix_time()),File.WRITE)
	file.store_32(OS.get_ticks_msec())
	file.close()

func _input(event):
	if event is InputEventScreenTouch:
		queue_free()
		$"..".new_menu()