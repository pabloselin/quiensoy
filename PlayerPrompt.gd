extends Control

var currentAvatar = preload("res://avatars/CurrentAvatar.tscn")
var handTextures = [preload("res://gfx/icons/mano_315.png"), preload("res://gfx/icons/mano_45.png"), preload("res://gfx/icons/mano_135.png"), preload("res://gfx/icons/mano_225.png")]


func init(thisplayer):
	var rotateTweenHand = $RotateHand
	var playerName = GameVars.playerProps[thisplayer]["name"]
	var score = GameVars.playerProps[thisplayer]["wins"]
	var scoreZone = $MarginContainer/Panel/HBoxContainer/VBoxContainer/Score
	var object = GameVars.playerProps[thisplayer]["object"]
	var hand = $MarginContainer/Panel/HBoxContainer/InfoAvatar/Mano
	var gameMode = $MarginContainer/Panel/HBoxContainer/VBoxContainer/GameMode
	var playerNameLabel = $MarginContainer/Panel/HBoxContainer/VBoxContainer/PlayerName
	var playerScoreLabel = $MarginContainer/Panel/HBoxContainer/VBoxContainer/Score/Wins
	playerNameLabel.visible = false
	scoreZone.visible = false
	
	gameMode.text = Utils.transitionMessage()
	if GameVars.transitionType == "minigame":
		scoreZone.visible = true
		playerNameLabel.visible = true
		playerScoreLabel.visible = true
		playerNameLabel.text = playerName
		playerScoreLabel.text = str(score)
			
	