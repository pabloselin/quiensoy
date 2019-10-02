extends Node2D

var score = 0
var winScore = 0
var offsetMove = 0
var speed = 10
onready var road = $Path2D/TricicloPath
signal minigamewin

func _ready():
	winScore = $Basura.get_child_count()

func _input(event):
	if event is InputEventScreenTouch:
		moveTriciclo(event.position)

func _process(delta):
	checkWin()
	if road.offset < 900 or road.offset > 0:
		road.offset += offsetMove
	
func _on_Triciclo_body_entered(body):
	score += 1
	body.queue_free()
	$Puf.play()
	
func moveTriciclo(position):
	if GameVars.currentPlayer == "player1" or GameVars.currentPlayer == "player2":
		if position.x > GameVars.gameSize[0] / 2:
			offsetMove = -speed
		elif position.x < GameVars.gameSize[0] / 2:
			offsetMove = speed
	elif GameVars.currentPlayer == "player3" or GameVars.currentPlayer == "player4":
		if position.x > GameVars.gameSize[0] / 2:
			offsetMove = speed
		elif position.x < GameVars.gameSize[0] / 2:
			offsetMove = -speed
			
func checkWin():
	if winScore == score:
		emit_signal("minigamewin")