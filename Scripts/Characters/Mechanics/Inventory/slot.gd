extends Panel

signal mouse_left_button_pressed(slot)
signal mouse_right_button_pressed(slot)

enum slot_type {
	default,
	helmet,
	chest,
	boots,
	weapon,
	delete
}

@export var type = slot_type.default

var _item = null

func put_item(item):
	item.get_parent().remove_child(item)
	_item = item
	add_child(_item)
	_item.set_inventory_mode(true)
	_item.position = Vector2.ZERO

func clear_item():
	_item = null

func pull_half_items() -> Node2D:
	var item = _item.duplicate()
	add_child(item)
	item.set_count(ceil(float(_item.get_count()) / 2))
	_item.set_count(_item.get_count() / 2)
	if _item.get_count() <= 0:
		_item.queue_free()
		_item = null
	return item

func get_item() -> Node2D:
	return _item

func has_item() -> bool:
	return _item != null

func same_item_with(item) -> bool:
	return item.ID == _item.ID

func _input(_event):
	if not (_event is InputEventMouseButton and _event.is_pressed()):
		return
	if not get_rect().has_point(get_parent().get_local_mouse_position()):
		return
	match _event.button_index:
		MOUSE_BUTTON_LEFT:
			mouse_left_button_pressed.emit(self)
		MOUSE_BUTTON_RIGHT:
			mouse_right_button_pressed.emit(self)
