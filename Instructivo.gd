extends Node2D

signal instructionsFinished

func _ready():
	var itemsSeq = $Secuencia.get_children()
	for i in itemsSeq.size():
		itemsSeq[i].visible = false
	$Papel.play("unfold")
	
func startInstructions():
	pass

func _on_AnimatedSprite_animation_finished():
	$AnimationPlayer.play("Instrucciones")
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("instructionsFinished")