extends Node

func _on_button_button_down():
	$CanvasLayer/Control/TipButton.visible = not $CanvasLayer/Control/TipButton.visible

func _on_switch_button_down():
	get_tree().quit()
