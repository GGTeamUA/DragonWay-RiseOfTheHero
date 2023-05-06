extends Node2D

enum item_type {
	default,
	helmet,
	chest,
	boots,
	weapon
}

@export var ID : int
@export var type = item_type.default
@export var item_name = ""
@export_multiline var description = ""
@export var _stack_limit = 64

var count : set = set_count, get = get_count
var free_count : get = get_free_count
var _count = 1

@onready var _pickable_object = $Area2D
@onready var _inventory_object = $Control
@onready var _count_label = $Control/Label
@onready var _item_pick_tip = $ItemPickTip

func add_count(count):
	_count += count
	_update_count()

func remove_count(count):
	_count -= count
	if _count <= 0:
		queue_free()
		return
	_update_count()

func set_count(count):
	_count = count
	_update_count()

func get_count() -> int:
	return _count

func get_free_count() -> int:
	return _stack_limit - _count

func set_inventory_mode(inventory_mode : bool):
	if inventory_mode:
		_pickable_object.visible = false
		_inventory_object.visible = true
	else:
		_pickable_object.visible = true
		_inventory_object.visible = false

func set_tip_visible(value : bool):
	_item_pick_tip.visible = value

func use():
	print("Used!")

func _update_count():
	_count_label.text = str(_count)

func _ready():
	_update_count()

