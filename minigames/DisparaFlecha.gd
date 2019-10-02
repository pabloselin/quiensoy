extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal minigamewin
onready var arrow = $Flecha
onready var cuerdaSup = $CuerdaSup
onready var cuerdaInf = $CuerdaInf
var arrowPosition = null
var stretchTime = 3
var moveX = -2
var overStretch = false
var readyToFire = false
var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
	arrowPosition = arrow.position

func _process(delta):
	moveArrow(delta)
	if readyToFire == true:
		$BowAnimation.play("ShakeBow")

func _input(event):
	if event is InputEventScreenTouch:
		if readyToFire == true:
			overStretch = true
			$Flechazo.play()
			moveX = 100
		
func moveArrow(delta):
	print("movearrow")
	print(str(arrow.position.x))
	if overStretch == false:
		if arrow.position.x > 500:
			arrow.move_and_collide(Vector2(moveX, 0))
			$Cuerda.points[1].x -= 2
			#arrow.position.x += moveX * delta
		else:
			readyToFire = true
	else:
		var collide = arrow.move_and_collide(Vector2(moveX, 0))
		if $Cuerda.points[1].x < 737:
			$Cuerda.points[1].x += 35
		if collide:
			$WallAnimation.play("ShakeArrow")
			yield($WallAnimation, "animation_finished")
			if win == false:
				emit_signal("minigamewin")
				win = true

func _on_Stretch_timeout():
	overStretch = true
