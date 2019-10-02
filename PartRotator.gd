extends Node2D

var curPlayerProps = GameVars.playerProps[GameVars.currentPlayer]
var arrparts = [GameVars.heads, GameVars.torsos, GameVars.feet]
var partLabels = ["CABEZA", "TORSO", "PIES"]
var part2Index = ["head", "torso", "feet"]
var changingPart = false
signal registeredPart
signal buildAvatar

var currentPart = 0
var currentIndex = 0
var currentInstance = null
export var curpart = "cabeza"
onready var timerSwitch = $Switch
onready var timerParts = $ChangePart
var switchTime = 0.3
var partChange = 10
var particleTime = 1


func _ready():
	timerSwitch.start(switchTime)
	timerParts.start(partChange)
	updateLabelPart()
	
# Rotate and animate different parts depending current part

func _input(event):
	if event is InputEventScreenTouch:
		if !changingPart:
			registerChosenPart(currentIndex)

func switchPart(part):	
	if currentInstance != null: 
		currentInstance.queue_free()
	
	var scene = arrparts[part][currentIndex]
	currentInstance = scene.instance()
	$PartZone.add_child(currentInstance)
	$SoundChange.play()
	$curpart.text = str(currentIndex)
	if currentIndex + 1 < arrparts[part].size():
		currentIndex += 1
	else:
		currentIndex = 0

func registerChosenPart(partIndex):
	#$curpart.text = str(partIndex)
	curPlayerProps[part2Index[currentPart]] = partIndex - 1
	$PickPart.play(0.89)
	emit_signal("registeredPart")
	$Click.emitting = true
	$ParticleTimer.start(particleTime)
	nextPartsGroup()

func nextPartsGroup():
	var prevPart = currentPart
	forcePutPart(prevPart)
	if currentPart + 1 < arrparts.size():		
		changingPart = true
		currentPart += 1
		updateLabelPart()
		$SoundChange.pitch_scale += .2		
		yield(get_tree().create_timer(0.5), "timeout")
	else:
		buildAvatar()
	changingPart = false
		
func buildAvatar():
	queue_free()
	emit_signal("buildAvatar")

func forcePutPart(prevPart):
	if curPlayerProps[part2Index[prevPart]] == null:
		curPlayerProps[part2Index[prevPart]] = currentIndex - 1
		emit_signal("registeredPart")
		# print(str(curPlayerProps[part2Index[currentPart]]))

func updateLabelPart():
	$CurrentPart.text = partLabels[currentPart]
			
func _on_Switch_timeout():
	switchPart(currentPart)

func _on_ChangePart_timeout():
	nextPartsGroup()

func _on_ParticleTimer_timeout():
	$Click.emitting = false