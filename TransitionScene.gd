extends Control

export var sceneDuration = 14

func _ready():
	$SceneDuration.start(sceneDuration)

func _input(event):
	if event is InputEventScreenTouch:
		SceneChanger.change_scene_tiled("res://PlayersStart.tscn")	

func _on_SceneDuration_timeout():
	SceneChanger.change_scene_tiled("res://PlayersStart.tscn")