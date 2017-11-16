extends Node2D

#Define the polygon


const poly_color = PoolColorArray([Color("FFFFFF")])

func _draw():
	self.draw_polyline_colors(global.vertices, poly_color,1.01)
	#self.set_polygon(global.vertices)
	self.set_scale(Vector2(8,8))
	self.position.x = global.cx
	self.position.y = global.cy
	#self.set_position(get_tree().get_root().get_node("game").center)
