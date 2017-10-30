extends Node2D


func _ready():
	get_node("Button").connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	get_tree().change_scene("res://scenes/game.tscn")