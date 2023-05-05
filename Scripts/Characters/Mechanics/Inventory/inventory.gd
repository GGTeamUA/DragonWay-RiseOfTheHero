extends Node

enum item_type {
	default,
	helmet,
	chest,
	boots,
	weapon
}

enum slot_type {
	delete = 5
}

var _holding_item = null

@onready var _inventory_window = $CanvasLayer/Control/MainWindow
@onready var _bar_slots = $CanvasLayer/Control/Bar/HBoxContainer
@onready var _main_slots = $CanvasLayer/Control/MainWindow/GridContainer
@onready var _control = $CanvasLayer/Control

func try_add_item(item) -> bool:
	for slot in get_tree().get_nodes_in_group("Slots"):
		if (slot.has_item() and slot.type == item_type.default 
		and slot.same_item_with(item) and item.get_count() <= slot.get_item().get_free_count()):
			slot.get_item().add_count(item.get_count())
			item.queue_free()
			return true
	for slot in get_tree().get_nodes_in_group("Slots"):
		if not slot.has_item() and slot.type == item_type.default:
			slot.put_item(item)
			return true
	return false

func _take_item(item):
	_holding_item = item
	_holding_item.get_parent().remove_child(_holding_item)
	_control.add_child(_holding_item)

func _on_slot_mouse_left_button_pressed(slot):
	if _holding_item:
		if slot.type == _holding_item.type:
			if slot.has_item():
				if slot.same_item_with(_holding_item) and slot.get_item().get_free_count() > 0:
					if slot.get_item().get_free_count() >= _holding_item.get_count():
						slot.get_item().add_count(_holding_item.get_count())
						_holding_item.queue_free()
						_holding_item = null
					else:
						var free_count = slot.get_item().get_free_count()
						slot.get_item().add_count(free_count)
						_holding_item.set_count(_holding_item - free_count)
				else:
					var item = slot.get_item()
					slot.put_item(_holding_item)
					_holding_item = item
			else:
				slot.put_item(_holding_item)
				_holding_item = null
		if slot.type == slot_type.delete:
			_holding_item.queue_free()
			_holding_item = null
	else:
		if slot.has_item():
			_take_item(slot.get_item())
			slot.clear_item()

func _on_slot_mouse_right_button_pressed(slot):
	if _holding_item:
		if slot.type == _holding_item.type:
			if slot.has_item():
				if slot.same_item_with(_holding_item) and slot.get_item().get_free_count() > 0:
					slot.get_item().add_count(1)
					_holding_item.remove_count(1)
					if _holding_item.get_count() == 0:
						_holding_item.queue_free()
						_holding_item = null
				else:
					var item = slot.get_item()
					slot.put_item(_holding_item)
					_holding_item = item
			else:
				var item = _holding_item.duplicate()
				add_child(item)
				_holding_item.remove_count(1)
				if _holding_item.get_count() == 0:
					_holding_item.queue_free()
					_holding_item = null
				slot.put_item(item)
		if slot.type == slot_type.delete:
			_holding_item.remove_count(1)
			if _holding_item.get_count() == 0:
				_holding_item.queue_free()
				_holding_item = null
	else:
		if slot.has_item():
			_take_item(slot.pull_half_items())

func _process(delta):
	if _holding_item:
		_holding_item.global_position = get_viewport().get_mouse_position()

func _ready():
	for slot in get_tree().get_nodes_in_group("Slots"):
		slot.mouse_left_button_pressed.connect(_on_slot_mouse_left_button_pressed)
		slot.mouse_right_button_pressed.connect(_on_slot_mouse_right_button_pressed)

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		_inventory_window.visible = not _inventory_window.visible
