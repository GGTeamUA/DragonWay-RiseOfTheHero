extends Node

enum item_type {
	default,
	helmet,
	chest,
	boots,
	weapon
}

var _holding_item = null

@onready var _inventory_window = $CanvasLayer/Control/MainWindow
@onready var _bar_slots = $CanvasLayer/Control/Bar/HBoxContainer
@onready var _main_slots = $CanvasLayer/Control/MainWindow/GridContainer

func try_add_item(item) -> bool:
	return false

func _on_slot_mouse_left_button_pressed(slot):
	pass

func _on_slot_mouse_right_button_pressed(slot):
	pass

func _process(delta):
	if _holding_item:
		_holding_item.position = get_viewport().get_mouse_position()

func _ready():
	for slot in get_tree().get_nodes_in_group("Slots"):
		slot.mouse_left_button_pressed.connect(_on_slot_mouse_left_button_pressed)
		slot.mouse_right_button_pressed.connect(_on_slot_mouse_right_button_pressed)

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		_inventory_window.visible = not _inventory_window.visible
