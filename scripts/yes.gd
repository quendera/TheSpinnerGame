extends CollisionPolygon2D

func _ready():
	position = Vector2(global.w*11/12,global.h*1/3)
	polygon = global.full_hex(global.poly_size)


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event.is_pressed() and event is InputEventScreenTouch:
		$"../..".queue_free()
		$"../../../../hex_root".start_game()

