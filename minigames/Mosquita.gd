extends AnimatedSprite

onready var flyposition = position

func _ready():
	pass
	
func _process(delta):
	randfly()
	
func randfly():
	print(str(flyposition))
	flyposition.x += 2
	flyposition.y += 2