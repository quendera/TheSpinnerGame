extends Node2D

#Define the polygon

var vertices = PoolVector2Array([Vector2(0,40),Vector2(34.6,20),Vector2(34.6,-20),Vector2(0,-40),Vector2(-34.6,-20),Vector2(-34.6,20),Vector2(0,40)])
const poly_color = PoolColorArray([Color("FFFFFF")])

func _draw():
	self.draw_polyline_colors(vertices, poly_color,1.01,false)
	self.set_scale(Vector2(8,8))
	self.position.x = global.cx
	self.position.y = global.cy
	#self.set_position(get_tree().get_root().get_node("game").center)
