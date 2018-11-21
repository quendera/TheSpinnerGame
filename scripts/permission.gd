extends AcceptDialog

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	popup_exclusive = true
	add_button("NO")
	dialog_text = "Do you agree to have your data collected anonymously?"
	connect("custom_action",self,"bye_bye")
	popup_centered()
	
func bye_bye():
	get_tree().quit()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
