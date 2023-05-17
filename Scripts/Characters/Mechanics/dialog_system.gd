extends Node

signal talking_ended

const WHITE = "#fff"
const GREY = "#3c3c3c"

var _index = 0
var _talking = false
var _block_replica_change = false
var _dialog
var _result_parsed


@onready var _dialog_window = $CanvasLayer
@onready var _npc_texture = $CanvasLayer/Control/NPCTexture
@onready var _hero_texture = $CanvasLayer/Control/HeroTexture
@onready var _npc_name = $CanvasLayer/Control/NPC/Label
@onready var _text = $CanvasLayer/Control/Text
@onready var _npc_name_panel = $CanvasLayer/Control/NPC
@onready var _hero_name_panel = $CanvasLayer/Control/You
@onready var _buttons = [$CanvasLayer/Control/Choices/Button1,
						$CanvasLayer/Control/Choices/Button2,
						$CanvasLayer/Control/Choices/Button3]

func start_talk(npc):
	_npc_texture.texture = npc.atlas
	_npc_name.text = npc.npc_name
	_result_parsed = npc.get_dialog()
	_dialog_window.show()
	
	for quest in _result_parsed["quests"]["quest_list"]:
		match _result_parsed["quests"][quest]["status"]:
			"available":
				start_dialog(quest)
			"active":
				pass
			"completed":
				continue

func start_dialog(dialog_name):
	_dialog = _result_parsed["dialogues"][dialog_name]
	_talking = true
	_index = 0
	_next_replica()

func end_talk():
	talking_ended.emit()
	_dialog_window.hide()

func _process(delta):
	if Input.is_action_just_pressed("skip") and _talking and not _block_replica_change:
		_next_replica()

func _next_replica():
	var replica = _dialog[_index]
	_block_replica_change = false
	
	match replica["speaker"]:
		"hero":
			_npc_texture.self_modulate = GREY
			_hero_texture.self_modulate = WHITE
			_npc_name_panel.hide()
			_hero_name_panel.show()
		"npc":
			_npc_texture.self_modulate = WHITE
			_hero_texture.self_modulate = GREY
			_npc_name_panel.show()
			_hero_name_panel.hide()
	
	for _button in _buttons:
		_button.hide()
	
	if replica["choices"]:
		_block_replica_change = true
		_hero_texture.self_modulate = WHITE
		_hero_name_panel.show()
		for i in range(len(replica["choices"])):
			_buttons[i].text = replica["choices"][i]["text"]
			_buttons[i].show()
			_buttons[i].set_data(replica["choices"][i])
	
	if _index == len(_dialog):
		end_talk()
	
	_text.text = replica["text"]
	_index += 1
