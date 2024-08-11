extends Control

var message_label
var init_pos

func _ready():
	message_label = $MessageLabel  # Assuming there's a Label named "MessageLabel"
	message_label.text = "Welcome to the Wumpus Game!"

func display_message(message):
	message_label.text = message

func new_position(pos):
	set_position(pos)
