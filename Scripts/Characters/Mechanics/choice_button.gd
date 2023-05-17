extends Button

var _choice_data

@onready var _dialog_system = $"../../../.."

func set_data(choice_data):
	_choice_data = choice_data

func _on_button_down():
	match _choice_data["event_type"]:
		"dialogues":
			_dialog_system.start_dialog(_choice_data["event"])
		"quests":
			pass
		"leave":
			_dialog_system.end_talk()
