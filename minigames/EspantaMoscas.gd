extends Node2D

signal minigamewin
signal minigamelose
var moscas = []
var pressed = false
var altTime = GameVars.miniGames["flies"]["time"] - .2

func _ready():
	moscas = $Moscas.get_children()
	$AltTimer.start(altTime)
	
func _process(delta):
	flytowards()
	flyaway()
	detect_flying()

func detect_flying():
	for i in moscas.size():
		var path = moscas[i].get_child(0)
		print(str(path.offset))
		if path.offset > 1200:
			emit_signal("minigamelose")

func flyaway():
	if pressed == true:
		for i in moscas.size():
			var path = moscas[i].get_child(0)
			if path.offset < 4000:
				path.offset -= 20

func flytowards():
	if pressed == false:
		for i in moscas.size():
			var path = moscas[i].get_child(0)
			path.offset += 10
			

func _on_DePie_pressed():
	pressed = true
	$AnimationPlayer.play("ShakeThing")
	$GiraMatraca.play()
	$Sonido.emitting = true
	$Sonido2.emitting = true
	$Matraca.modulate = Color(0, 0, 1)

func _on_DePie_released():
	pressed = false
	$AnimationPlayer.stop()
	$GiraMatraca.stop()
	$Sonido.emitting = false
	$Sonido2.emitting = false
	$Matraca.modulate = Color(1, 1, 1)

func _on_AltTimer_timeout():
	emit_signal("minigamewin")