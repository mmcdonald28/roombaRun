extends Node

class_name GameManager


func _ready():
	get_tree().change_scene_to_file("res://menuMainMenu.tscn")
	#when game opens, it goes to the main menu

