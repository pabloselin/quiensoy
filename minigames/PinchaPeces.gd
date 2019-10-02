extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal minigamewin
var score = 0
var winscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var peces = get_children()
	winscore = peces.size()
	for i in peces.size():
		peces[i].connect("explode", self,  "add_point")

func _process(delta):
	if score == winscore and winscore > 0:
		print("win")
		emit_signal("minigamewin")

func add_point():
	score += 1
