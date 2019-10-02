extends Node2D

func init(thisplayer):
	var rotateTweenHand = $RotateHand
	var hands = $PointHand
	var rotation = GameVars.playerProps[thisplayer]["angle"]
	$PointHand.rotation_degrees = 0
	rotateTweenHand.interpolate_property($PointHand, "rotation_degrees", 0, rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	rotateTweenHand.start()