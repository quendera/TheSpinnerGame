extends CollisionPolygon2D

func _ready():
	position = Vector2(global.w*11/12,global.h*2/3)
	polygon = global.full_hex(global.poly_size)

func _on_Area2D2_input_event(_viewport, event, _shape_idx):
	if event.is_pressed():
		get_tree().quit() 
