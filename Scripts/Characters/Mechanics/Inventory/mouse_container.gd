extends Control

var holding_item : get = get_holding_item, set = set_holding_item

func has_holding_item() -> bool:
	return get_child_count() == 1

func set_holding_item(new_item):
	if new_item.get_parent():
		new_item.get_parent().remove_child(new_item)
	add_child(new_item)
	new_item.position = Vector2.ZERO

func get_holding_item() -> Node2D:
	return get_child(0) if get_child_count() == 1 else null

func pull_holding_item() -> Node2D:
	var new_item = get_holding_item()
	remove_child(new_item)
	return new_item

func delete_holding_item():
	holding_item.queue_free()
