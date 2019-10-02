extends Control

export var sceneDuration = 20

func _ready():
	$SceneDuration.start(sceneDuration)

func _input(event):
	if event is InputEventScreenDrag:
		SceneChanger.change_scene_tiled("res://PlayersStart.tscn")	

func _on_SceneDuration_timeout():
	SceneChanger.change_scene_tiled("res://PlayersStart.tscn")