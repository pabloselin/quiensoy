extends Node2D

export var player = ""

func _ready():
	if player.length() == 0:
		player = GameVars.currentPlayer
		
	if GameVars.playerProps[player]["head"] != null:
		buildCurrentAvatar()

func buildCurrentAvatar():
	var finalhead = GameVars.playerProps[player]["head"]
	var finaltorso = GameVars.playerProps[player]["torso"]
	var finalfeet = GameVars.playerProps[player]["feet"]
	var colorMod =  GameVars.playerProps[player]["color"]["value"]
	
	var instanceHead =  GameVars.heads[finalhead].instance()
	var instanceTorso = GameVars.torsos[finaltorso].instance()
	var instanceFeet = GameVars.feet[finalfeet].instance()
		
	$CurrentHead.add_child(instanceHead)
	$CurrentTorso.add_child(instanceTorso)
	$CurrentFeet.add_child(instanceFeet)
	
	$CurrentHead.modulate = colorMod
	$CurrentTorso.modulate = colorMod
	$CurrentFeet.modulate = colorMod