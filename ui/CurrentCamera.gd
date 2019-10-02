extends Camera2D

func _ready():
	if GameVars.currentPlayer == "player1" or GameVars.currentPlayer == "player2":
		self.rotation_degrees = 180
	else:
		self.rotation_degrees = 0
