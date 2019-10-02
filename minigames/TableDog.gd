extends Node2D

onready var dog = $DogSurf
var topLeft = -45
var topRight = 45
var curAngle = 0
var angleProgress = .3
var almostTimeOut = 4.6
signal minigamelose
signal minigamewin

func _ready():
	$AlmostCountDown.start(almostTimeOut)

func _process(delta):
	rotateDog()
	trackDog()

func _input(event):
	if event is InputEventScreenTouch:
		moveDog(event.position)

func moveDog(position):
	if GameVars.currentPlayer == "player1" or GameVars.currentPlayer == "player2":
		if position.x > GameVars.gameSize[0] / 2:
			angleProgress -= .2
		elif position.x < GameVars.gameSize[0] / 2:
			angleProgress += .2
	elif GameVars.currentPlayer == "player3" or GameVars.currentPlayer == "player4":
		if position.x > GameVars.gameSize[0] / 2:
			angleProgress += .2
		elif position.x < GameVars.gameSize[0] / 2:
			angleProgress -= .2
	
		
func rotateDog():
	if dog.rotation > .7:
		dog.rotation_degrees -= .6
		poorDog()
	elif dog.rotation < -.7:
		dog.rotation_degrees += .6
		poorDog()
	else:
		dog.rotation_degrees += angleProgress

func trackDog():
	dog.modulate = rotationToColor(dog.rotation)

func poorDog():
	emit_signal("minigamelose")

func rotationToColor(rotation):
	var dogInt = 0
	if rotation > 0:
		dogInt = rotation
	else:
		dogInt = rotation * -1
	var colorRotation = Color(dogInt + 1, 1, 1)
	
	return colorRotation
	

func _on_AlmostCountDown_timeout():
	emit_signal("minigamewin")