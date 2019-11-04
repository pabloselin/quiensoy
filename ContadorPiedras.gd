extends Control

var scoreStoneWin = preload("res://ui/MiniGameStoneWin.tscn")
export var player = "player1"

func _ready():
	pass
	
func updateScoreStone():
	var score = GameVars.playerProps[player]["wins"]
	var prevStones = self.get_children()
	for stone in prevStones.size():
		prevStones[stone].queue_free()
	for piedra in range(score - 1):
		var scoreStoneInstance = scoreStoneWin.instance()
		self.add_child(scoreStoneInstance)