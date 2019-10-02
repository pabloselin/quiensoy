extends Node2D
var playerObjects = {}

func init(thisplayer):
	var curplayer = GameVars.playerProps[thisplayer]
	var curobject = curplayer["object"]
	var order = curplayer["order"]
	if curobject:
		var item = load(curobject)
		$TurnObject.texture = item
		$TurnObject.modulate = curplayer["color"]["value"]
		$TurnObject.visible = true