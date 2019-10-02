extends Node

var bodySeconds = 10
var parts = ["head", "torso", "feet"]
var currentpart = parts[0]
var isAvatarBuilt = false

func _ready():
	$PlayerLabel.visible = false
	$PlayerLabel.text = str(GameVars.currentPlayer)
	$ResultZone/ZoneFrame.visible = false
	$Playa.modulate = GameVars.playerProps[GameVars.currentPlayer]["color"]["value"]

func _on_PartRotator_registeredPart():
	var head = GameVars.playerProps[GameVars.currentPlayer]["head"]
	var torso = GameVars.playerProps[GameVars.currentPlayer]["torso"]
	var feet = GameVars.playerProps[GameVars.currentPlayer]["feet"]
	
func _on_PartRotator_buildAvatar():
	if !isAvatarBuilt:
		var finalhead = GameVars.playerProps[GameVars.currentPlayer]["head"]
		var finaltorso = GameVars.playerProps[GameVars.currentPlayer]["torso"]
		var finalfeet = GameVars.playerProps[GameVars.currentPlayer]["feet"]
		GameVars.playerProps[GameVars.currentPlayer]["name"] =  Utils.buildName(GameVars.currentPlayer) 
		
		if finalhead != null and finaltorso != null and finalfeet != null:
			var instanceHead =  GameVars.heads[finalhead].instance()
			var instanceTorso = GameVars.torsos[finaltorso].instance()
			var instanceFeet = GameVars.feet[finalfeet].instance()
			
			$paper_lines.visible = false
			$paper_lines2.visible = false
			$PickPart.play()
			yield($PickPart, "finished")
			$ResultZone/ZoneFrame.visible = true
			$ResultZone/ZoneFrame.play("appear")
			$Redoble.play()
			$Fog.emitting = true
			$Fog2.emitting = true
			$Fog3.emitting = true
			yield($Redoble, "finished")
			$Fog.emitting = false
			$Fog2.emitting = false
			$Fog3.emitting = false
			var readyHead = $ResultZone/FinalHead.add_child(instanceHead)
			var readyTorso = $ResultZone/FinalTorso.add_child(instanceTorso)
			var readyFeet = $ResultZone/FinalFeet.add_child(instanceFeet)
			$PlayerLabel.text = GameVars.playerProps[GameVars.currentPlayer]["name"]
			$PlayerLabel.visible = true
			isAvatarBuilt = true
			$FinalAvatarTimer.start(5)


func _on_FinalAvatarTimer_timeout():
	SceneChanger.change_scene_tiled("res://Main.tscn")