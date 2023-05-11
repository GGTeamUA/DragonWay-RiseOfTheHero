extends StaticBody2D

@export_multiline var _text

@onready var _message = $Message
@onready var _label = $Message/Label

func _ready():
	_label.text = _text

func _on_area_2d_body_entered(body):
	_message.visible = true

func _on_area_2d_body_exited(body):
	_message.visible = false
