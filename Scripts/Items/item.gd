extends Node2D

enum item_type {
	default,
	helmet,
	chest,
	boots,
	weapon
}

@export var ID : int
@export var _type = item_type.default
@export var _stack_limit = 64
@export var _name = ""
@export_multiline var _description = ""

var _count = 1

@onready var _pickable_object = $Area2D
@onready var _inventory_object = $TextureRect

func set_inventory_mode(inventory_mode : bool):
	if inventory_mode:
		_pickable_object.visible = false
		_inventory_object.visible = true
	else:
		_pickable_object.visible = true
		_inventory_object.visible = false

func use():
	print("Used!")

