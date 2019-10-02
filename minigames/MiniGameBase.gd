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

var curMiniGame = null

func _ready():
	startMiniGame()
	
func _process(delta):
	$GameTimeOut/TimeLeft.text = str(int($Timer.time_left))
	if success == true:
		$RebootTimer.start(rebootTime)
	
func chooseMiniGame():
	var miniGames = GameVars.miniGames.values()
	# var miniGames = [tableDog]
	randomize()
	var randGameSize = randi() % miniGames.size()
	var miniGame = miniGames[randGameSize]
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
	$GameTimeOut/Inflate.play()
	$GameTimeOut/FishCountDown.play("idle")

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
	$UnfoldBG.play("unfold", true)
	yield(get_tree().create_timer(1), "timeout")
	
	if Utils.isGameFinished():
		SceneChanger.change_scene_tiled("res://FinalScene.tscn")
	else:
		SceneChanger.change_scene_tiled("res://Main.tscn")
	
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