extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.is_debug_build():
		self.hide()
	$FPSLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fps_label_toggled():
		$FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second()) 

func fps_label_toggled() -> bool:
	var pause_menu = $"../PauseMenu"
	if pause_menu:
		var options_menu = pause_menu.get_node("OptionsMenu")
		if options_menu:
			var debug_node = options_menu.get_node("TabContainer").get_node("Debug")
			if debug_node:
				if debug_node.display_fps_toggled:
					$FPSLabel.show()
					return true
				else:
					$FPSLabel.hide()
					return false
	return false
