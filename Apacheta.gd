extends Node2D

var stoneSpeed = 0
var availableStones = 20
var reachedStones = 0
var increment = 600
export var debug = false
var playerCurves = {}
var redoblePlaying = false
var transitionStarted = false
signal updateScoreStones

func _ready():
	playerCurves = {
		"player1": {
			"name": "player1",
			"curve": $Piedras/PiedrasPlayer1,
			"counter": $Score/ContadorPiedras1,
			"zona": $Zonas/PlayerIndicator1,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player1"]["wins"],
			"built": false
			},
		"player2": {
			"name": "player2",
			"curve": $Piedras/PiedrasPlayer2,
			"counter": $Score/ContadorPiedras2,
			"zona": $Zonas/PlayerIndicator2,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player2"]["wins"],
			"built": false
			},
		"player3": {
			"name": "player3",
			"curve": $Piedras/PiedrasPlayer3,
			"counter": $Score/ContadorPiedras3,
			"zona": $Zonas/PlayerIndicator3,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player3"]["wins"],
			"built": false
			},
		"player4": {
			"name": "player4",
			"curve": $Piedras/PiedrasPlayer4,
			"counter": $Score/ContadorPiedras4,
			"zona": $Zonas/PlayerIndicator4,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player4"]["wins"],
			"built": false
			}
		}
	if debug == true:
		Utils.debugPlayers(["player1", "player2", "player3", "player4"])
		for playerCurve in playerCurves.values():
			playerCurve["points"] = 5
			GameVars.playerProps[playerCurve["name"]]["wins"] = 5

	checkActivePlayers()
	$Ayudas/MoveHand.play("moveAround")
	for playerCurve in playerCurves.values():
		self.connect("updateScoreStones", playerCurve["counter"], "updateScoreStone")
	emit_signal("updateScoreStones")
	
	
func _process(delta):
	moveStones(delta)
	trackOffset()
	updateScore()
	checkBuilt()

func _input(event):
	if event is InputEventScreenTouch:
		$Ayudas.visible = false
		detectPlayerPress(event.position)
		$AvatarNoises.play(0.5)
		stoneSpeed += 10
		

func updateScore():
	for playerCurve in playerCurves.values():
		var score = playerCurve["points"] - playerCurve["timesHit"]
		#$ContadorPiedras1.init(score)
		var label = playerCurve.curve.get_children()
		label[1].text = str(score)

func moveStones(delta):
	for playerCurve in playerCurves.values():
		var pathFollow = playerCurve.curve.get_children()
		var speed = playerCurve.speed
		pathFollow[0].offset += delta * speed
		
func trackOffset():
	for playerCurve in playerCurves.values():
		var pathFollow = playerCurve.curve.get_children()
		var length = playerCurve.curve.get_curve().get_baked_length()
		var offset = pathFollow[0].offset
		var prevHits = playerCurve["timesHit"]
		if offset > 0:
			var hits = int(offset / length)
			playerCurve["timesHit"] = hits
			checkApachetaBuilt()
			if prevHits != int(offset / length):
				playerCurve["speed"] = 0
				$AnimationPlayer.play("Glow")
				pointSound(playerCurve)
				GameVars.playerProps[playerCurve["name"]]["wins"] -= 1
				emit_signal("updateScoreStones")

func checkApachetaBuilt():
	for playerCurve in playerCurves.values():
		if playerCurve["timesHit"] - playerCurve["points"] == 0:
			if playerCurve["built"] == false:
				playerCurve["built"] = true
	
func checkBuilt():
	var isBuilt = true
	for playerCurve in playerCurves.values():
		if playerCurve["built"] == false:
			isBuilt = false
		if playerCurve["built"] == true:
			playerCurve["curve"].visible = false
	
	if isBuilt == true:
		if transitionStarted == false:
			transitionStarted = true
			$RotateHole.play("Rotate", -1, 4)
			$ShowApacheta/Redoble.play()
			yield(get_tree().create_timer(1), "timeout")
			$RotateHole.play("RotateandResize", -1, 6)
			$ShowApacheta/AnimateApacheta.play("FadeIn")
			yield(get_tree().create_timer(4), "timeout")
			SceneChanger.change_scene_tiled("res://FinalScene.tscn")
	
	
func checkActivePlayers():
	for player in playerCurves.values():
		if GameVars.playerProps[player["name"]]["active"] == false:
			player["curve"].queue_free()
			playerCurves.erase(player["name"])

func pointSound(player):
	$InTheHole.play()

func detectPlayerPress(position):
		if position.x > GameVars.screenSize.x / 2:
			#Puede ser player dos o cuatro
			if position.y > GameVars.screenSize.y / 2:
				speedUp("player4")
			else:
				speedUp("player2")
		elif position.x < GameVars.screenSize.x / 2:
			#Puedes er player uno o tres
			if position.y > GameVars.screenSize.y / 2:
				speedUp("player3")
			else:
				speedUp("player1")
		
func speedUp(player):
	if playerCurves.has(player) and playerCurves[player]["built"] == false:
		playerCurves[player].speed += increment
		playerCurves[player]["zona"].modulate = Color(1, 1, 1, .3)
		yield(get_tree().create_timer(0.1), "timeout")
		playerCurves[player]["zona"].modulate = Color(1, 1, 1, 0)
				
func transformStone(player):
	pass