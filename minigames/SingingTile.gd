extends Node2D

onready var singTile = $SingTile
var singtimes = 0
var singgoal = 2
var whoSings = [false, false, false, false]
var tileIndex = [$TileContainer/SingTile, $TileContainer/SingTile2, $TileContainer/SingTile3, $TileContainer/SingTile4]
signal minigamewin

func _ready():
	pass

func _process(delta):
	checkWin()

func checkWin():
	var isWin = 0
	for i in whoSings.size():
		if whoSings[i] == true:
			isWin += 1
	if isWin == 4:
		yield(get_tree().create_timer(1), "timeout")
		emit_signal("minigamewin")
	
func _on_SingTile_pressed():
	whoSings[0] = true

func _on_SingTile2_pressed():
	whoSings[1] = true

func _on_SingTile3_pressed():
	whoSings[2] = true

func _on_SingTile4_pressed():
	whoSings[3] = true