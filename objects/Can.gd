extends StaticBody2D

var trail = preload("res://items/Trail.tscn")

func _ready():
	pass


func _on_TouchScreenButton_pressed():
	var plop = trail.instance()
	add_child(plop)
	$CanTexture.visible = false
	$CollisionShape2D.disabled = true
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	queue_free()