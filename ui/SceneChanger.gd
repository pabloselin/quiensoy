extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var curtain = $Control/Curtain
onready var grid = $Control/GridContainer
var tileTexture = load("res://gfx/tiles/tile_A.png")

func change_scene( path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("Fade")
	emit_signal("scene_changed")
	
func change_scene_tiled( path, delay = 0.5):
	var tileSize = tileTexture.get_size()
	var numberTilesX = GameVars.screenSize.x / tileSize.x
	var numberTilesY = GameVars.screenSize.y / tileSize.y
	var numberTiles = numberTilesX * numberTilesY + 20
	grid.columns = numberTilesX + 2
	
	for i in range(numberTiles / 4):
		for i in range(4):		
			var tile = TextureRect.new()
			tile.texture = tileTexture
			grid.add_child(tile)
		yield(get_tree().create_timer(0), "timeout")
		
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	
	assert(get_tree().change_scene(path) == OK)
	
	animation_player.play_backwards("Fade")
	
	var childTiles = grid.get_children()
	var yieldDif = 0
	for i in childTiles.size():
		childTiles[i].queue_free()
		yieldDif += 1
		if yieldDif % 4 == 0:
			yield(get_tree().create_timer(0), "timeout")
	
	
	