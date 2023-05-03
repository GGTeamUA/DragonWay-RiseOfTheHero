extends Node

signal value_changed(mana : float)

@export var _max_mana : float = 100

var _current_mana : float
	
func reduce(value : float):
	_current_mana -= value
	if _current_mana <= 0:
		_current_mana = 0
	value_changed.emit(_current_mana)

func restore(value : float):
	_current_mana += value
	if _current_mana > _max_mana:
		_current_mana = _max_mana
	value_changed.emit(_current_mana)

func _ready():
	_current_mana = _max_mana
