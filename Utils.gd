extends Node

func updatePlayerObject(playerkey, property, value):
	GameVars.playerProps[keyToPlayer(playerkey)][property] =  value
	
func keyToPlayer(playerkey):
	return "player" + str(playerkey + 1)
	
func getActivePlayers():
	var activePlayers = []
	# Returns an array of active players
	for i in GameVars.playerProps.size():
		var curplayer = "player" + str(i+1)
		if GameVars.playerProps[curplayer]["active"] == true:
			activePlayers.push_back(curplayer)
	return activePlayers
	
func assignPlayersOrder():
	var activePlayers = getActivePlayers()
	print(str(activePlayers))
	randomize()
	var shuffledPlayers = activePlayers
	shuffledPlayers.shuffle()
	for i in shuffledPlayers.size():
		GameVars.playersOrder.push_back(shuffledPlayers[i])

func initialPlayersOrder():
	var players = getActivePlayers()
	for i in players.size():
		GameVars.playersOrder.push_back(players[i])
	
func getPlayerTurn():
	var curplayer = GameVars.currentPlayer
	if GameVars.playersOrder.size() > 0:
		GameVars.currentPlayer = GameVars.playersOrder.front()
		GameVars.playersOrder.pop_front()
		GameVars.playersOrder.push_back(GameVars.currentPlayer)

func playerHasAvatar(player):
	print(str(GameVars.playerProps[player].head))
	if GameVars.playerProps[player].head != null and GameVars.playerProps[player].torso != null and GameVars.playerProps[player].feet != null:
		return true
	else:
		return false
		
func allPlayersHaveAvatars():
	var players = GameVars.playersOrder
	print(str(GameVars.playersOrder))
	var allHaveAvatars = true
	for i in players.size():
		if !playerHasAvatar(players[i]):
			allHaveAvatars = false
	if allHaveAvatars == true:
		GameVars.transitionType = "minigame"
	return allHaveAvatars

func getPlayerScore(player):
	return GameVars.playerProps[player]["wins"]
	
func getPlayerLoses(player):
	return GameVars.playerProps[player]["loses"]
	
func getPlayerGamesPlayed(player):
	return getPlayerScore(player) + getPlayerLoses(player)

func getTotalGamesPlayed():
	var players = ["player1", "player2", "player3", "player4"]
	var total = 0
	for i in players.size():
		total += getPlayerScore(players[i]) + getPlayerLoses(players[i])
	return total
	
func getTotalGamesAllowed():
	return GameVars.activePlayers().size() * 5
	
func isGameFinished():
	var activePlayers = GameVars.activePlayers()
	var playersFinished = 0
	for i in activePlayers.size():
		print(str(getPlayerGamesPlayed(activePlayers[i])))
		if getPlayerGamesPlayed(activePlayers[i]) >= GameVars.gamesPerPlayer:
			playersFinished += 1
	if playersFinished == activePlayers.size():
		return true
	else:
		return false

func resetPlayerProps():
	GameVars.transitionType = "avatar"
	GameVars.playerProps = GameVars.cleanPlayerProps.duplicate(true)
				
func buildName(player):
	randomize()
	var randKey = randi() % GameVars.nameList.size()
	var pickName = GameVars.nameList[randKey]
	GameVars.nameList.remove(randKey)
	var pickColor = GameVars.playerProps[player]["color"]["name"]
	
	return pickName + " " + pickColor
	
func debugPlayers(activePlayers):
	for i in activePlayers.size():
		GameVars.playerProps[activePlayers[i]]["active"] = true