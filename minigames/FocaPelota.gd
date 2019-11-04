extends Node2D

var motion = Vector2(0, 0)
var speed = 500
onready var foca = $Foca
onready var pelota = $Pelota
var bounces = 0
var winbounces= 3
signal minigamewin
signal minigamelose

func _ready():
	pelota.bounce = 1
	
func _physics_process(delta):
	var focapos = foca.position.x
	var pelotapos = pelota.position.y
	var collide = foca.move_and_collide(motion * delta)
	
	if bounces > winbounces:
		emit_signal("minigamewin")
		
	if focapos > GameVars.screenSize.x:
		motion = Vector2(100, 0)
	if focapos < 0:
		motion = Vector2(-100, 0)
	
	if pelotapos > GameVars.screenSize.y:
		emit_signal("minigamelose")
	
		
func _input(event):
	if event is InputEventScreenTouch:
		moveSeal(event.position)

func moveSeal(position):
	if GameVars.currentPlayer == "player1" or GameVars.currentPlayer == "player2":
		if position.x > GameVars.gameSize[0] / 2:
			motion.x = -speed
		elif position.x < GameVars.gameSize[0] / 2:
			motion.x = speed
	elif GameVars.currentPlayer == "player3" or GameVars.currentPlayer == "player4":
		if position.x > GameVars.gameSize[0] / 2:
			motion.x = speed
		elif position.x < GameVars.gameSize[0] / 2:
			motion.x = -speed

func _on_Pelota_body_entered(body):
	print("collide")
	$Bounce.play(0.91)
	bounces += 1