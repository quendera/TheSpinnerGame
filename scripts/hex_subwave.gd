extends Polygon2D

var total_coords

func _ready():
	if global.scorebar_mode == 0:
		total_coords = global.full_hex((global.poly_size*3*2-global.side_offset*2)/sqrt(3),1)
		var coords = global.full_hex((global.poly_size*3*2+global.side_offset*2)/sqrt(3),1)
		position = Vector2(coords[0].x+global.h*global.padding/2,global.centre.y)#$"../hex_progress".position
		color = global.hint_color(6)
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2))
		position = Vector2(global.scorebar_anchor+global.poly_size*4,global.h/2)
		color = global.hint_color(0)
		
func _draw():
	draw_polyline(global.score_hex(global.poly_size/sqrt(3),Vector2(0,-global.stretch/2),Vector2(0,0),1),global.hex_color(6,1),3)

func total_points(angle):
	if global.scorebar_mode == 0:
		if angle > 0.01: #prevents poor polygon formation when it is too small
			show()
			polygon = global.pie_hex(total_coords,angle)
		else:
			hide()
	else:
		polygon = global.score_hex(global.poly_size/sqrt(3),Vector2(0,global.stretch/2),Vector2(0,-global.stretch*angle))
