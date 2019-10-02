extends Node2D

signal explode

onready var explosion = $RutaNado/BichosNadando/ItemPez/Explosion
onready var botonexplosion = $RutaNado/BichosNadando/ItemPez/TouchZone
onready var camino = $RutaNado/BichosNadando

# Called when the node enters the scene tree for the first time.
func _ready():
	explosion.visible = false

func _process(delta):
	camino.offset += 10

func _on_TouchScreenButton_pressed():
	botonexplosion.visible = false
	explosion.visible = true
	explosion.play("explode")
	yield(get_tree().create_timer(0.35), "timeout" )
	$Bang.play()
	emit_signal("explode")
	