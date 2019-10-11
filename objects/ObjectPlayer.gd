extends Sprite

# Assigns random sprite
var objects = GameVars.playerObjects

func _ready():
	#var objects = GameVars.playerObjects
	if objects.size() > 0:
		randomize()
		var randomInt = randi() % objects.size()
		var randobject = objects[randomInt]
		var item = load("res://gfx/player_objects/" + randobject)
		# Removes used object so it doesn't repeat
		GameVars.playerObjects.remove(randomInt)
		#print(str(objects.size()))
		get_node(".").texture = item