extends Control


func _ready():
	self.hide()

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("pause") and !event.is_echo():
		#print("pause pressed")
		if get_tree().paused:
			hide_options_menu_if_visible()
			self.hide()
			get_tree().paused = false
		else:
			self.show()
			get_tree().paused = true
	
	if !self.hidden:
		if event is InputEventKey || event is InputEventMouseButton:
			# Consumes the event after passing through the UI Control Node
			# emmiting a signal that the event is conclude to other processes
			self.accept_event()

func _on_quit_to_desktop_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	if get_tree().paused:
		hide_options_menu_if_visible()
		self.hide()
		get_tree().paused = false

func _on_options_button_pressed():
	$VBoxContainer.hide()

func _on_options_menu_hidden():
	$VBoxContainer.show()
	

# Method to hide Options menu in case player leaves pause directly without backing out
func hide_options_menu_if_visible() -> void:
	if $OptionsMenu.is_visible_in_tree():
		$OptionsMenu.hide()
