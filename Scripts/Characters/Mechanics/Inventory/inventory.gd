extends Node

signal weapon_equipped(qeuipped : bool)

enum slot_type {
	default,
	helmet,
	chest,
	boots,
	weapon,
	delete
}

var _holding_item : get = _get_holding_item, set = _set_holding_item

@onready var _mouse_container = $CanvasLayer/MouseContainer
@onready var _inventory_window = $CanvasLayer/Control/MainWindow
@onready var _bar_slots = $CanvasLayer/Control/Bar/HBoxContainer
@onready var _main_slots = $CanvasLayer/Control/MainWindow/GridContainer
@onready var _description = $CanvasLayer/Control/MainWindow/Description

func try_add_item(item) -> bool:
	#try to find the same item
	for slot in get_tree().get_nodes_in_group("Slots"):
		if not slot.type == slot_type.default:
			continue
		if not slot.has_item():
			continue
		if not slot.same_item_with(item):
			continue
		if not slot.item.free_count >= item.count:
			continue
		slot.item.add_count(item.count)
		item.queue_free()
		return true
	#try to find a free slot
	for slot in get_tree().get_nodes_in_group("Slots"):
		if not slot.type == slot_type.default:
			continue
		if slot.has_item():
			continue
		slot.put_item(item)
		return true
	return false

func _get_holding_item() -> Node2D:
	return _mouse_container.holding_item

func _set_holding_item(new_item):
	_mouse_container.holding_item = new_item

func _on_slot_mouse_left_button_pressed(slot):
	if _mouse_container.has_holding_item():
		match slot.type:
			slot_type.default, _holding_item.type:
				if slot.has_item():
					if slot.same_item_with(_holding_item) and slot.item.free_count > 0:
						if slot.item.free_count >= _holding_item.count:
							slot.item.add_count(_holding_item.count)
							_mouse_container.delete_holding_item()
						else:
							slot.item.add_count(slot.item.free_count)
							_holding_item.remove_count(slot.item.free_count)
					else:
						var item = slot.pull_item()
						slot.item = _mouse_container.pull_holding_item()
						_holding_item = item
				else:
					slot.item = _mouse_container.pull_holding_item()
			slot_type.delete:
				_mouse_container.delete_holding_item()
	else:
		if slot.has_item():
			_holding_item = slot.pull_item()

func _on_slot_mouse_right_button_pressed(slot):
	if _mouse_container.has_holding_item():
		match slot.type:
			slot_type.default, _holding_item.type:
				if slot.has_item():
					if slot.same_item_with(_holding_item) and slot.item.free_count > 0:
						slot.item.add_count(1)
						_holding_item.remove_count(1)
					else:
						var item = slot.pull_item()
						slot.item = _mouse_container.pull_holding_item()
						_holding_item = item
				else:
					slot.item = _holding_item.duplicate()
					_holding_item.remove_count(1)
			slot_type.delete:
				_holding_item.remove_count(1)
	else:
		if slot.has_item():
			_holding_item = slot.pull_half_items()

func _on_slot_mouse_entered(slot):
	if slot.has_item():
		_description.text = slot.item.description

func _on_slot_mouse_exited(slot):
	_description.text = ""

func _process(delta):
	if _mouse_container.has_holding_item():
		_mouse_container.global_position = get_viewport().get_mouse_position()

func _ready():
	for slot in get_tree().get_nodes_in_group("Slots"):
		slot.mouse_left_button_pressed.connect(_on_slot_mouse_left_button_pressed)
		slot.mouse_right_button_pressed.connect(_on_slot_mouse_right_button_pressed)
		slot.slot_mouse_entered.connect(_on_slot_mouse_entered)
		slot.slot_mouse_exited.connect(_on_slot_mouse_exited)

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		_inventory_window.visible = not _inventory_window.visible


func _on_weapon_slot_item_pulled(item):
	weapon_equipped.emit(false)


func _on_weapon_slot_item_puted(item):
	weapon_equipped.emit(true)
