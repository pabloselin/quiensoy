extends Node2D

var arepaPosition
onready var arepa = $Arepa
signal minigamewin
var eaten = false
onready var cangrejo = $Path2D/PathFollow2D/Cangrejo

func _process(delta):
	if $Path2D/PathFollow2D.position.x > arepaPosition.x + 200:
		chomp() 

func _ready():
	if arepa != null:
		arepaPosition = arepa.position

func _input(event):
	if event is InputEventScreenTouch:
		moveCrab()
		
func moveCrab():
	$Caminando.play()
	$Path2D/PathFollow2D.offset += 35
	$CrabWalk.play("Walk")
	
func chomp():
	if eaten == false:
		$Comiendo.play()
		eaten = true
		arepa.queue_free()
		yield($Comiendo,"finished")
		emit_signal("minigamewin")
		