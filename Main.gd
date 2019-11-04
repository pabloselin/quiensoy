extends Control

onready var camara = $Camera2D
onready var tween = $CameraTween
var isPlaying = false
var playerNames = []
onready var gameprompt = $Container/GamePrompt
var transitionTime = 2

var scoreStone = preload("res://ui/MiniGameStone.tscn")
var scoreStoneWin = preload("res://ui/MiniGameStoneWin.tscn")
var playerTurns = preload("res://PlayerTurns.tscn").instance()
var playerPrompt = preload("res://PlayerPrompt.tscn").instance()

# Descripcion de la mision con un texto

func _ready():
	Utils.allPlayersHaveAvatars()
	Utils.getPlayerTurn()	
	var player = GameVars.currentPlayer
	
	if GameVars.transitionType == "avatar":
		$Sonidos/AvatarPrompt.play()
	elif GameVars.transitionType == "minigame":
		Utils.assignPlayersOrder()
		$Sonidos/Acelerate.play()

	playerPrompt.init(player)
	var prompt = add_child(playerPrompt)
	yield(get_tree().create_timer(1), "timeout")
	playerPrompt.rect_rotation = 180
	#$Fondo.modulate = GameVars.playerProps[player]["color"]["value"]
	$TransitionTimeOut.start(transitionTime)
	
# Zooms to selected player position
func zoomToPlayer(player):
	tween.interpolate_property(camara, "zoom", GameVars.initialZoom, GameVars.activePlayerZoom, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(camara, "position", camara.position, GameVars.playerPositions[player], 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
# Zooms back to main view	
func zoomToMain():
	tween.interpolate_property(camara, "zoom", camara.get_zoom(), GameVars.initialZoom, 1, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(camara, "position", camara.position, GameVars.initialCameraPosition, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	tween.start()

func _on_CameraTween_tween_all_completed():
	if GameVars.transitionType == "minigame":
		yield(get_tree().create_timer(2), "timeout")
		SceneChanger.change_scene_tiled("res://minigames/MiniGameBase.tscn", 0.01)
	elif GameVars.transitionType == "avatar":
		yield(get_tree().create_timer(.5), "timeout")
		SceneChanger.change_scene_tiled("res://AvatarRoulette.tscn")

func putPlayerNames():
	var playerLabels = [$PlayerNames/Player1Container/PlayerName, $PlayerNames/Player2Container/PlayerName, $PlayerNames/Player3Container/PlayerName, $PlayerNames/Player4Container/PlayerName]
	
	for i in playerNames.size():
		playerLabels[i].visible = false
		if playerNames[i] != null:
			playerLabels[i].text = playerNames[i]
			playerLabels[i].visible = true

func putPlayerScores():
	var playerScores = [$PlayerNames/Player1Container/Score, $PlayerNames/Player2Container/Score, $PlayerNames/Player3Container/Score, $PlayerNames/Player4Container/Score]
	
	
	var curPlayerKey = 0
	for player in GameVars.playerProps:
		var wins = GameVars.playerProps[player].wins
		var loses = GameVars.playerProps[player].loses
			
		if wins > 0:
			for i in range(wins):
				print("addwin")
				var scoreStoneInstance = scoreStoneWin.instance()
				playerScores[curPlayerKey].add_child(scoreStoneInstance)
		if loses > 0:
			for i in range(loses):
				print("addlose")
				var scoreStoneInstance = scoreStone.instance()
				playerScores[curPlayerKey].add_child(scoreStoneInstance)
		
		curPlayerKey += 1						

func _on_TransitionTimeOut_timeout():
	if GameVars.transitionType == "minigame":
		#yield(get_tree().create_timer(2), "timeout")
		SceneChanger.change_scene_tiled("res://minigames/MiniGameBase.tscn", 0.01)
	elif GameVars.transitionType == "avatar":
		#yield(get_tree().create_timer(.5), "timeout")
		SceneChanger.change_scene_tiled("res://AvatarRoulette.tscn")
