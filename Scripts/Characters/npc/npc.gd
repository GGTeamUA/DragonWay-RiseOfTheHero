extends CharacterBody2D

const INTERACT_TYPE = "npc"

@export var atlas : AtlasTexture
@export_file var data_path_file

var npc_name : get = _get_name

@onready var _npc_tip = $NPCTip
@onready var _npc_name_label = $Name/Label

func on_hero_visible(value : bool):
	_npc_tip.visible = value

func get_dialog():
	return _get_load_json_file()

func _get_load_json_file():
	var data_file = FileAccess.open(data_path_file, FileAccess.READ)
	var parsed_result = JSON.parse_string(data_file.get_as_text())
	data_file.close()
	
	return parsed_result

func _get_name() -> String:
	return _npc_name_label.text
