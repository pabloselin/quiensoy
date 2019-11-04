extends Node2D

signal minigamewin
signal minigamelose
onready var arrow = $Flecha
onready var cuerdaSup = $CuerdaSup
onready var cuerdaInf = $CuerdaInf
var arrowPosition = null
var stretchTime = 3
var moveX = -2
var moveY = 0
var moveString = 0
var overStretch = false
var readyToFire = false
var win = false
var lose = false
var textAction = "ESPERA"
var textReady = "DISPARA!"

# Called when the node enters the scene tree for the first time.
func _ready():
	arrowPosition = arrow.position
	$Increment.start()
	$TextAnimation.play("WaitBounce")

func _process(delta):
	moveArrow(delta)
	moveCuerda()
	setText()
	if readyToFire == true:
		$BowAnimation.play("ShakeBow")

func _input(event):
	if event is InputEventScreenTouch:
		if readyToFire == true:
			overStretch = true
			$Flechazo.play()
			moveX = 100
		else:
			moveX = 0
			moveY = 20
			$ArrowAnimation.play("ArrowAnimation")
			moveString = 0
			lose = true
			yield(get_tree().create_timer(0.6), "timeout")
			emit_signal("minigamelose")
		
func moveArrow(delta):
	if overStretch == false:
		if arrow.position.x > 460:
			arrow.move_and_collide(Vector2(moveX, moveY))
			moveString = -2
			#arrow.position.x += moveX * delta
		else:
			readyToFire = true
	else:
		var collide = arrow.move_and_collide(Vector2(moveX, moveY))
		if $Cuerda.points[1].x  > 400:
			moveString = -35
		if collide:
			$WallAnimation.play("ShakeArrow")
			if win == false:
				$Rebote.play()
				win = true
				yield($Rebote, "finished")
				emit_signal("minigamewin")
				


func moveCuerda():
	if lose == false:
		if $Cuerda.points[1].x > 420:
			print(str($Cuerda.points[1].x))
			$Cuerda.points[1].x += moveString
	else:
		if $Cuerda.points[1].x < 740:
			$Cuerda.points[1].x += 10

func setText():
	if readyToFire == true:
		$ActionPrompt.text = textReady
		$Increment.stop()
		$TextAnimation.play("ActionBounce")
	else:
		$ActionPrompt.text = textAction
		
func _on_Stretch_timeout():
	overStretch = true


func _on_Increment_timeout():
	textAction += ". "
