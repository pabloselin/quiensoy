extends Control

func _ready():
	pass

func _input(event):
	if event is InputEventScreenTouch:
		get_tree().change_scene("res://Intro.tscn")