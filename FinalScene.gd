extends Node2D

func _ready():
	pass

func _input(event):
	if event is InputEventScreenTouch:
		get_tree().change_scene("res://Intro.tscn")

func _process(delta):
	$Vehiculos/Path2D/PathFollow2D.offset += 1