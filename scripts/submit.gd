extends CollisionPolygon2D

func _ready():
	position = Vector2(global.w*11/12*.66,global.h*1/4*.66)
	polygon = global.full_hex(global.poly_size*.66)

func _on_Area2D2_input_event(_viewport, event, _shape_idx):
	if event.is_pressed() and event is InputEventScreenTouch:
		$"../../survey".write_data()
		$"../..".queue_free()
		$"../../../../hex_root/data_send".search_and_send()
		$"../../../../hex_root".new_menu()
