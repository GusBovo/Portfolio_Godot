extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_options_button_pressed():
	self.show()

func _on_back_button_pressed():
	self.hide()
