extends CharacterBody2D

const INTERACT_TYPE = "npc"

var npc_name : get = _get_name

@onready var _npc_tip = $NPCTip
@onready var _npc_name_label = $Name/Label

func on_hero_visible(value : bool):
	_npc_tip.visible = value

func _get_name() -> String:
	return _npc_name_label.text
