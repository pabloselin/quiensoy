extends Node2D

signal minigamewin
var turtlepos = Vector2(0,0)


func _process(delta):
	turtlepos = $Turtle.position
	checkwin(turtlepos)

func checkwin(turtlepos):
	if turtlepos.x < 0:
		emit_signal("minigamewin")