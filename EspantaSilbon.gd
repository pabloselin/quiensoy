extends Node2D

signal minigamewin
signal minigamelose

var almostTimeOut = GameVars.miniGames["silbon"]["time"] - 0.4
var attackMotion = Vector2(-600, 0)
var escapeMotion = Vector2(300, 0)
var motion = Vector2(0, 0)
var isbarking = false
var whistling = false

func _ready():
	motion = attackMotion
	$WinSilbon.start(almostTimeOut)
	$Silbido.play()

func _input(event):
	if event is InputEventScreenTouch:
		if !isbarking:
			bark()
			
func _physics_process(delta):
	var collision = $Silbon.move_and_collide(motion * delta)
	var silbonpos = $Silbon.position.x
	if silbonpos > GameVars.screenSize.x:
		emit_signal("minigamewin")
	if collision:
		emit_signal("minigamelose")
	
func bark():
	isbarking = true
	var barkDog = load("res://gfx/objects/perro2.png")
	var normalDog = load("res://gfx/objects/perro1.png")
	motion = escapeMotion
	$Ladrido.play()
	$Silbido.stop()
	$AnimationPlayer.play("ShakeDog")
	$Dog/perro.texture = barkDog
	if whistling == false:
		whistling = true
		$SilbidoDown.play()
	yield($Ladrido, "finished")
	$AnimationPlayer.stop(true)
	isbarking = false
	$Dog/perro.texture = normalDog
	motion = attackMotion

func _on_WinSilbon_timeout():
	emit_signal("minigamewin")


func _on_SilbidoDown_finished():
	whistling = false