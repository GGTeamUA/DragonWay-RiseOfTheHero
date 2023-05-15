extends Panel

signal mouse_left_button_pressed(slot)
signal mouse_right_button_pressed(slot)
signal slot_mouse_entered(slot)
signal slot_mouse_exited(slot)
signal item_puted(item)
signal item_pulled(item)

enum slot_type {
	default,
	helmet,
	chest,
	boots,
	weapon,
	delete
}

@export var type = slot_type.default

var item : get = get_item, set = put_item

func put_item(new_item):
	if new_item.get_parent():
		new_item.get_parent().remove_child(new_item)
	add_child(new_item)
	new_item.set_inventory_mode(true)
	new_item.position = Vector2.ZERO
	item_puted.emit(new_item)

func pull_item() -> Node2D:
	var new_item = item
	remove_child(new_item)
	item_pulled.emit(new_item)
	return new_item

func pull_half_items() -> Node2D:
	var new_item = item.duplicate()
	var item_count = ceil(float(item.get_count()) / 2)
	get_parent().add_child(new_item)
	new_item.set_count(item_count)
	item.remove_count(item_count)
	if item_count == 1:
		item_pulled.emit(new_item)
	return new_item

func get_item() -> Node2D:
	return get_child(0) if get_child_count() == 1 else null

func has_item() -> bool:
	return get_child_count() == 1

func same_item_with(new_item) -> bool:
	return new_item.ID == item.ID

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

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	slot_mouse_entered.emit(self)

func _on_mouse_exited():
	slot_mouse_exited.emit(self)
