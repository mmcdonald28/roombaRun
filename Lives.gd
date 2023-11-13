# gd for the lives and their function

extends Control

var heart_size: int = 10

func _live_changed(hearts: float) -> void:
	$Lives.rect_size.x = hearts * heart_size
