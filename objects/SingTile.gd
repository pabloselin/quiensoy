extends Node2D

var singTexture = preload("res://gfx/tiles/facetile_01.png")
var muteTexture = preload("res://gfx/tiles/facetile_02.png")

var sounds = [preload("res://sfx/arranado.wav"), preload("res://sfx/avatar.wav"), preload("res://sfx/chanchito.wav"), preload("res://sfx/cui1.wav"), preload("res://sfx/cui2.wav"), preload("res://sfx/ladrido1.wav")]

export var index = 0
signal pressed

func _ready():
	pass

func _on_SingTile_pressed():
	pickRandomSound()
	$Song.play()
	$Shake.play("Shake")
	$TileContainer/SingTile.normal = singTexture
	emit_signal("pressed")

func pickRandomSound():
	randomize()
	var randInt = randi() % sounds.size()
	$Song.stream = sounds[randInt]

func _on_SingTile_released():
	#$Song.stop()
	pass

func _on_Song_finished():
	$TileContainer/SingTile.normal = muteTexture
