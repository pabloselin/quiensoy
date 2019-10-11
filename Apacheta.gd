extends Node2D

var stoneSpeed = 0
var availableStones = 20
var reachedStones = 0
var increment = 30
export var debug = false
var playerCurves = {}

func _ready():
	playerCurves = {
		"player1": {
			"curve": $PiedrasPlayer1,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player1"]["wins"],
			"built": false
			},
		"player2": {
			"curve": $PiedrasPlayer2,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player2"]["wins"],
			"built": false
			},
		"player3": {
			"curve": $PiedrasPlayer3,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player3"]["wins"],
			"built": false
			},
		"player4": {
			"curve": $PiedrasPlayer4,
			"speed": 0,
			"timesHit": 0,
			"points": GameVars.playerProps["player4"]["wins"],
			"built": false
			}
		}
	checkActivePlayers()
	
	if debug == true:
		for playerCurve in playerCurves.values():
			playerCurve["points"] = 2

	
func _process(delta):
	moveStones(delta)
	trackOffset()
	updateScore()
	checkBuilt()

func _input(event):
	if event is InputEventScreenTouch:
		detectPlayerPress(event.position)
		$AvatarNoises.play(0.5)
		stoneSpeed += 10
		

func updateScore():
	for playerCurve in playerCurves.values():
		var label = playerCurve.curve.get_children()
		label[1].text = str(playerCurve["points"] - playerCurve["timesHit"])

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
	
	if isBuilt == true:
		SceneChanger.change_scene("res://FinalScene.tscn", 0.5)
	
	
func checkActivePlayers():
	for playerkey in playerCurves:
		if GameVars.playerProps[playerkey]["active"] == false:
			playerCurves[playerkey]["curve"].queue_free()
			playerCurves.erase(playerkey)

func pointSound(player):
	print(str(player))
	$InTheHole.play()

func detectPlayerPress(position):
		if position.x > GameVars.screenSize.x / 2:
			#Puede ser player dos o cuatro
			if position.y > GameVars.screenSize.y / 2:
				print(str("player4"))
				speedUp("player4")
			else:
				print(str("player2"))
				speedUp("player2")
		elif position.x < GameVars.screenSize.x / 2:
			#Puedes er player uno o tres
			if position.y > GameVars.screenSize.y / 2:
				print(str("player3"))
				speedUp("player3")
			else:
				print(str("player1"))
				speedUp("player1")
		
func speedUp(player):
	if playerCurves.has(player) and playerCurves[player]["built"] == false:
		playerCurves[player].speed += increment
				
func transformStone(player):
	pass