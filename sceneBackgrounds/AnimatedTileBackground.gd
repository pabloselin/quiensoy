extends Control

func _ready():
	if GameVars.currentPlayer != null:
		modulate = GameVars.playerProps[GameVars.currentPlayer]["color"]