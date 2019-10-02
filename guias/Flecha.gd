extends Node2D

func _ready():
	randBlink()

func randBlink():
	randomize()
	var randTime = randi() % 6
	$BlinkTime.start(randTime)
	
func _on_BlinkTime_timeout():
	$Flecha.set_frame(0)
	$Flecha.play("blink")