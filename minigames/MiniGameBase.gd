extends Node2D

# Ideas microjuegos

# - sacar un pajarito, un cangrejo o un chungungo en resto de red de pesca o en un plástico de cervezas (esos con 6 circulitos), animalito  escurridizo que se vuelve a enrollar
#
# - escobillar una mancha de fuel en un animalito, mancha animada (con carita) y escurridiza
#
# - insonorizar un ruido: capturar un ruido (un monstruito muy ruidoso) con un elemento de vidrio
#
# - con un detector de metal, detectar unos bichos mutantes que son mitad cangrejos (o pulgas de mar) mitad resortes que salen de la arena enojados y te persiguen
#
# - una nube de abejas mariadas y desorientas se vienen directo hacia ti, y tienes que dominarlos con poder mental, sacarlas de ese estado con hipnosis para liberarlas
#
# - recoger cacas de animales (perro, chungungos, cangrejos, pulgas de mar, focas, gaviotas, con una manito robot
#
# - invocar espíritus de la tierra, que hagan temblar y el cerro despierta y sopla la contaminación del aire
#
# - capturar nubecitas toxicas con una aspiradora de olores

var success = false
var timeout = 5
var rebootTime = 0.5
var minigameName = null
var curMiniGame = null
var scoreStone = preload("res://ui/MiniGameStone.tscn")
var scoreStoneWin = preload("res://ui/MiniGameStoneWin.tscn")

func _ready():
	yield(get_tree().create_timer(.5),"timeout")
	startMiniGame()
	
func _process(delta):
	$GameTimeOut/TimeLeft.text = str(int($Timer.time_left))
	if success == true:
		$RebootTimer.start(rebootTime)
	
func chooseMiniGame():
	var miniGames = GameVars.currentMiniGames.values()
	# var miniGames = [tableDog]
	if miniGames.size() > 0:
		randomize()
		var randGameSize = randi() % miniGames.size()
		var miniGame = miniGames[randGameSize]
		GameVars.currentMiniGames.erase(miniGame)
		minigameName = miniGame["name"]
		timeout = miniGame.time
		var randGame = load(miniGame.scene)
		return randGame
		
func startMiniGame():
	$UnfoldBG.play("unfold")
	var curMiniGame = chooseMiniGame().instance()
	$MiniGameZone.add_child(curMiniGame)
	#print(str(gameInstance))
	curMiniGame.connect("minigamewin", self, "_on_minigamewin")
	curMiniGame.connect("minigamelose", self, "_on_minigamelose")
	$Timer.start(timeout)
	putLabels()
	$GameTimeOut/Inflate.play()
	$GameTimeOut/FishCountDown.play("idle")

func putLabels():
	$GameName.text = minigameName
	var wins = GameVars.playerProps[GameVars.currentPlayer]["wins"]
	var loses = GameVars.playerProps[GameVars.currentPlayer]["loses"]
	
	for i in range(wins):
		var scoreStoneInstance = scoreStoneWin.instance()
		scoreStoneInstance.modulate = Color(0.168627, 0.788235, 0.098039)
		$Score.add_child(scoreStoneInstance)
	for i in range(loses):
		var scoreStoneInstance = scoreStone.instance()
		scoreStoneInstance.modulate = Color(0.804688, 0.084869, 0.084869)
		$Score.add_child(scoreStoneInstance)
	
	if GameVars.playerProps[GameVars.currentPlayer]["name"]:
		$AvatarName.text = GameVars.playerProps[GameVars.currentPlayer]["name"]

func  chooseWinAnimation():
	var personajes = ["ShowMalku", "ShowSkaty", "ShowSurf", "ShowFlecha"]
	randomize()
	return personajes[randi() % personajes.size()]

func endMiniGame():
	$MiniGameZone.visible = false
	$MiniGameZone.queue_free()
	$Timer.stop()
	if success == true:
		$GameTimeOut/FishCountDown.play("win")	
		$GameTimeOut/Success.play()
		$ShowPersonaje.play(chooseWinAnimation())
		add_win()
	else:
		$GameTimeOut/FishCountDown.play("explode")
		$GameTimeOut/Lose.play()
		$ShowPersonaje.play("ShowDefeat")
		$GameTimeOut/Explode.play()
		add_lose()
	
	yield($ShowPersonaje, "animation_finished")
	$GameTimeOut.visible = false
	$CurrentAvatar.visible = false
	$GameName.visible = false
	$AvatarName.visible = false
	$Score.visible = false
	$UnfoldBG.play("unfold", true)
	yield(get_tree().create_timer(1), "timeout")
	
	if Utils.isGameFinished():
		SceneChanger.change_scene_tiled("res://Apacheta.tscn")
	else:
		SceneChanger.change_scene_tiled("res://Main.tscn", 0.01)
	
func add_win():
	GameVars.playerProps[GameVars.currentPlayer]["wins"] += 1
	
func add_lose():
	GameVars.playerProps[GameVars.currentPlayer]["loses"] += 1
	
func _on_RebootTimer_timeout():
	$RebootTimer.stop()
	startMiniGame()

func _on_minigamewin():
	success = true
	endMiniGame()
	
func _on_minigamelose():
	success = false
	endMiniGame()
	
func _on_Timer_timeout():
	success = false
	endMiniGame()