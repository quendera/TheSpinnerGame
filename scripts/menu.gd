extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("Button").connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	get_tree().change_scene("res://scenes/game.tscn")