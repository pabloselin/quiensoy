extends Node2D

func _ready():
	var players = [$Player1, $Player2, $Player3, $Player4]
	var activePlayers = GameVars.activePlayers()
	for i in activePlayers.size():
		updatePlayerScore(players[i], activePlayers[i])
		
func updatePlayerScore(player, activePlayer):
	player.text = GameVars.playerProps[activePlayer]["wins"]