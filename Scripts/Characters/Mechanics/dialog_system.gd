extends Node

const WHITE = "#fff"
const GREY = "#3c3c3c"

var _index = 0
var _talking = false
var _dialog

@onready var _dialog_window = $CanvasLayer
@onready var _npc_texture = $CanvasLayer/Control/NPCTexture
@onready var _hero_texture = $CanvasLayer/Control/HeroTexture
@onready var _npc_name = $CanvasLayer/Control/NPC/Label
@onready var _text = $CanvasLayer/Control/Text
@onready var _npc_name_panel = $CanvasLayer/Control/NPC
@onready var _hero_name_panel = $CanvasLayer/Control/You

func start_talk(npc):
	_npc_texture.texture = npc.atlas
	_npc_name.text = npc.npc_name
	var result_parsed = npc.get_dialog()
	
	for quest in result_parsed["quests"]["quest_list"]:
		match result_parsed["quests"][quest]["status"]:
			"available":
				_start_dialog(result_parsed["dialogues"][quest])
			"active":
				pass
			"completed":
				continue

func _input(event):
	if Input.is_action_just_pressed("skip") and _talking:
		_next_replica()

func _start_dialog(dialog):
	_dialog = dialog
	_talking = true
	_index = 0
	_dialog_window.show()
	_next_replica()

func _next_replica():
	var replica = _dialog[_index]
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
		
	_text.text = replica["text"]
	_index += 1
