extends Node

signal value_changed(health : float)

@export var _max_health : float = 100

var _current_health : float
	
func damage(value : float):
	_current_health -= value
	if _current_health <= 0:
		_current_health = 0
	value_changed.emit(_current_health)

func heal(value : float):
	_current_health += value
	if _current_health > _max_health:
		_current_health = _max_health
	value_changed.emit(_current_health)

func _ready():
	_current_health = _max_health
