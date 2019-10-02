extends Sprite

var objects = [
	"arepa_02.png",
	"arepa_01.png",
	"arepa_03.png",
	"botella_01.png",
	"botella_02.png",
	"bote_01.png",
	"bote_02.png",
	"cangrejo_01.png",
	"cangrejo_02.png"
]

# Assigns random sprite

func _ready():
	#var objects = GameVars.playerObjects
	if objects.size() > 0:
		randomize()
		var randomInt = randi() % objects.size()
		var randobject = objects[randomInt]
		var item = load("res://gfx/player_objects/" + randobject)
		# Removes used object so it doesn't repeat
		objects.remove(randomInt)
		get_node(".").texture = item