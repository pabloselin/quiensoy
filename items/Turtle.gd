extends KinematicBody2D

var speed = 0
var motion = Vector2(-20000, 0)
var top = 120
var bottom = GameVars.screenSize[1] - 220 
var randomY = randPos()


func _physics_process(delta):
	print(randomY)
	move_and_slide(motion * delta)
	detectBorders()

func _ready():
	position.y = randomY
	
func randPos():
	randomize()
	print(bottom, top)
	var number = randf() * bottom + top
	return number
	
func detectBorders():
	if position.y < top:
		position.y += 1
	elif position.y > bottom:
		position.y -= 1
			