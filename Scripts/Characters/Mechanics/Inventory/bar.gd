extends TextureRect

var _selected_slot

@onready var _bar_slots = $HBoxContainer
@onready var _select_rect = $SelectRect

func _select_slot(index : int):
	_selected_slot = _bar_slots.get_child(index)
	_select_rect.position.x = index * 19 + 6

func _ready():
	_select_slot(0)

func _input(_event):
	if Input.is_action_just_pressed("use_selected_item"):
		if _selected_slot.has_item():
			_selected_slot.get_item().use()

	if Input.is_action_just_pressed("select_slot_1"):
		_select_slot(0)
	if Input.is_action_just_pressed("select_slot_2"):
		_select_slot(1)
	if Input.is_action_just_pressed("select_slot_3"):
		_select_slot(2)
	if Input.is_action_just_pressed("select_slot_4"):
		_select_slot(3)
	if Input.is_action_just_pressed("select_slot_5"):
		_select_slot(4)
	if Input.is_action_just_pressed("select_slot_6"):
		_select_slot(5)
	if Input.is_action_just_pressed("select_slot_7"):
		_select_slot(6)
	if Input.is_action_just_pressed("select_slot_8"):
		_select_slot(7)
	if Input.is_action_just_pressed("select_slot_9"):
		_select_slot(8)
	if Input.is_action_just_pressed("select_slot_10"):
		_select_slot(9)
