extends Panel

signal mouse_left_button_pressed(slot)
signal mouse_right_button_pressed(slot)

enum item_type {
	default,
	helmet,
	chest,
	boots,
	weapon
}

@export var _type = item_type.default

var _item = null

func get_item() -> Node2D:
	return _item

func has_item() -> bool:
	return _item != null

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
