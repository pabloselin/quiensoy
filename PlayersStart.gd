extends Node2D

var timeToStart = 5
var helpTime = 12
var instructionsTime = 10
var timerScale = 1
var isCountDownFinished = false
var playerOrder = 0
var playerAnimations = []
var playerObjects = []
var playerButtons = []
var colorkeys = ["yellow", "green", "lightblue", "red"]
var readyToPlay = false
var globoapretando = [preload("res://sfx/globoapretando01.wav"),preload("res://sfx/globoapretando02.wav"),preload("res://sfx/globoapretando03.wav"),preload("res://sfx/globoapretando04.wav"),preload("res://sfx/globoapretando05.wav"),preload("res://sfx/globoapretando06.wav"),preload("res://sfx/globoapretando07.wav")]
var globoapretandores = []

onready var seconds = $TimerUI/Seconds
onready var timerTexts = [$TimerUI/TimerText, $TimerUI/TimerText2, $TimerUI/TimerText3, $TimerUI/TimerText4]
onready var ayudas = weakref($Ayudas)
onready var player1 = $Players/Player1
onready var player2 = $Players/Player2
onready var player3 = $Players/Player3
onready var player4 = $Players/Player4

signal player_unfolded
signal player_folded

func _ready():
	positionPlayers()


func positionPlayers():
	# Position and rotate the players
	playerAnimations = [$Players/PlayerAnimations/Player1Animation, $Players/PlayerAnimations/Player1Animation2, $Players/PlayerAnimations/Player1Animation3, $Players/PlayerAnimations/Player1Animation4]
	
	playerObjects = [$Players/PlayerObjects/ObjectPlayer1, $Players/PlayerObjects/ObjectPlayer2, $Players/PlayerObjects/ObjectPlayer3, $Players/PlayerObjects/ObjectPlayer4]
	
	for i in playerObjects.size():
		Utils.updatePlayerObject(i, "object", playerObjects[i].texture.get_path())
		
	
	playerButtons = [player1, player2, player3, player4]
	
	if ayudas.get_ref():
		$Ayudas/MoveHand.play("moveAround")
	
	$TimerUI/TimerPez/PezGlobo.play("idle")
	$TimerUI/TimerPez/AnimationPlayer.play("Shake")
	
	connect("player_folded", self, "playerFolded")
	connect("player_unfolded", self, "playerUnfolded")
	readyToPlay = true
	for i in playerButtons.size():
		playerButtons[i].connect("pressed", self, "playAnimationPlayer", [i])
		playerAnimations[i].connect("animation_finished", self, "playerAssignTurn", [i])

func playerAssignTurn(playerkey):
	if seconds.is_stopped():
		seconds.start(1)
		disableHelp()
	playerOrder += 1
	Utils.updatePlayerObject(playerkey, "active", true)
	Utils.updatePlayerObject(playerkey, "order", playerOrder)
	playerObjects[playerkey].visible = true
	playerAssignColor(playerkey)

func disableHelp():
	if ayudas.get_ref():
		$Ayudas.queue_free()
	
func _input(event):
	if event is InputEventScreenTouch:
		if seconds.is_stopped() and readyToPlay == true:
			updateLabel(str(timeToStart))
		
func playAnimationPlayer(playerkey):
	playerAnimations[playerkey].play("unfold")
	$Sounds/Player1Sound.play()
	
func playerAssignColor(playerkey):
	randomize()
	print(str(playerkey))
	var randomColor = randi() % colorkeys.size()
	var playerColor = GameVars.colors[colorkeys[randomColor]]
	playerAnimations[playerkey].modulate = playerColor["value"]
	print(str(playerColor["name"]))
	colorkeys.remove(randomColor)
	Utils.updatePlayerObject(playerkey, "color", playerColor)
	
func animateTimer():
	$TimerUI/CircleTween.start()
	$TimerUI/TimerPez/PezGlobo.play("countdown")
	$TimerUI/TimerPez/AnimationPlayer.play("FastShake")
	$Sounds/CountDown.play()

func updateLabel(text):
	for i in timerTexts.size():
		timerTexts[i].text = text
	
func _on_Seconds_timeout():
	if timeToStart < 1:
		if !isCountDownFinished:
			isCountDownFinished = true
			GameVars.playerItems = playerObjects
			$Sounds/Explode.play()
			$TimerUI/TimerPez/PezGlobo.play("explode")
			$Camera2D/AnimationPlayer.play("ZoomStart")
			yield($Camera2D/AnimationPlayer, "animation_finished")
			Utils.initialPlayersOrder()
			SceneChanger.change_scene_tiled("res://Main.tscn")
	else:
		$Sounds/CountDown.play()
		updateLabel(str(timeToStart))
		timeToStart -= 1
		animateTimer()

func startStart():
	$Instructivo.visible = false
	$Skip.visible = false
	$ColorRect.visible = false
	$FadeBg.play("Fade")
	positionPlayers()


func _on_Instructivo_instructionsFinished():
	startStart()

func _on_Skip_pressed():
	startStart()