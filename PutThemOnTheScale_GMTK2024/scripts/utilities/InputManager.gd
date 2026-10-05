extends Node

const USER_SETTINGS_FILE_PATH : String = "user://input_settings.cfg"

var key_mapping : Dictionary = {}

func _ready():
	load_key_mappings()
	setup_input_actions()

# Setup default input actions and assign keys
func setup_input_actions() -> void:
	for action in key_mapping.keys():
		var keys = key_mapping[action]
		InputMap.action_erase_events(action)
		if typeof(keys) == TYPE_ARRAY:
			for key in keys:
				if typeof(key) == TYPE_DICTIONARY:
					var keycode = key.get("keycode", null)
					var modifier = key.get("modifier", 0)
					if keycode != null:
						pass
					else:
						print_debug("Invalid key mapping format for action:", action)
				else:
					print_debug("Invalid keys format for action:", action)

# Apply custom key mappings if any

# Save the custom key mappings to project settings
func save_custom_key_mappings():
	pass
	# Optionally save to file or other persistent storage here

# Load custom key mappings from project settings or file
func load_key_mappings() -> void:
	var file = FileAccess.open(USER_SETTINGS_FILE_PATH, FileAccess.READ)
	if !file:
		file.close()
		file = FileAccess.open(USER_SETTINGS_FILE_PATH, FileAccess.WRITE)

		file.close()
		key_mapping
	else:
		print_debug("Failed to open " + USER_SETTINGS_FILE_PATH + " file for writing default keybindings")
	
	if file:
		if file.get_length() > 0:
			key_mapping = file.get_var()
			file.close()
			print_debug("Successfully loaded dictionary from: ", USER_SETTINGS_FILE_PATH)
		elif file.get_length() == 0:
			file.close()
			file = FileAccess.open(USER_SETTINGS_FILE_PATH, FileAccess.WRITE)

			file.close()
		else:
			print_debug("File in ", USER_SETTINGS_FILE_PATH, " is empty or does not exist")
			file.close()
	else:
		print_debug("Failed to open ", USER_SETTINGS_FILE_PATH, " file for reading")

# Helper function to create InputEventKey
func create_input_event_key(keycode):
	var event = InputEventKey.new()
	event.keycode = keycode
	return event
