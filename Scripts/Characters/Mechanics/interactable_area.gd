extends Area2D

signal interacted(interacted_object)

var _interactable_objects = []
var _interactable_object = null

func _find_closed_object() -> Node2D:
	if len(_interactable_objects) == 0:
		return null
	var object = _interactable_objects[0]
	for item in _interactable_objects:
		if global_position.distance_to(item.global_position) < global_position.distance_to(object.global_position):
			object = item
	return object

func _input(event):
	if Input.is_action_just_pressed("interact"):
		if _interactable_object:
			interacted.emit(_interactable_object)

func _on_area_entered(area):
	_on_body_entered(area.get_parent())

func _on_area_exited(area):
	_on_body_exited(area.get_parent())

func _on_body_entered(body):
	_interactable_objects.append(body)
	if _interactable_object:
		_interactable_object.on_hero_visible(false)
	_interactable_object = _find_closed_object()
	_interactable_object.on_hero_visible(true)

func _on_body_exited(body):
	_interactable_objects.erase(body)
	if body == _interactable_object:
		_interactable_object.on_hero_visible(false)
		_interactable_object = _find_closed_object()
	if _interactable_object:
		_interactable_object.on_hero_visible(true)
