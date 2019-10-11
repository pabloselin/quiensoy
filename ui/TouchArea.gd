extends Control

var glow = preload("res://ui/TouchIndicator.tscn")

func _ready():
	pass

func _input(event):
	if event is InputEventScreenTouch:
		showTouch(event.position)
		
func showTouch(position):
	var newGlow = glow.instance()
	newGlow.position = position
	print(str(position))
	var newGlowInstance = self.add_child(newGlow)
	yield(get_tree().create_timer(0.3), "timeout")
	newGlow.queue_free()
	