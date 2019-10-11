extends Node
# Global game variables
# Comentarios
# Tortuga añadir mas obstaculos
# Revisar la boca que habla
var gameVersion = "0.2.7.3"
var playerObjects = [
	"arepa_02.png",
	"arepa_01.png",
	"arepa_03.png",
	"botella_01.png",
	"botella_02.png",
	"bote_01.png",
	"bote_02.png",
	"cangrejo_01.png",
	"cangrejo_02.png",
	"fruta.png",
	"matraca.png",
	"pescadito.png",
	"silbon.png",
	"tambor_01.png",
	"tortuga.png",
	"cruzafro.png",
	"apacheta.png",
	"canchita.png",
	"viento.png"
]
# Phone Screen Size
var screenSize = OS.get_screen_size()
var gameSize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
var activePlayerZoom = Vector2(0.5, 0.5)
var initialZoom = Vector2(0.5, 0.5)
var initialCameraPosition = Vector2(gameSize.x / 2, gameSize.y / 2)
var gamesPerPlayer = 5
var currentPlayer = "player3"


var nameList = ["suri", "kusi", "panqarita", "kurmi", "qhantati", "nayra", "allin", "pawkar", "amaru", "suni", "wara wara", "amaya", "antawara", "katari", "qhantuta", "quri", "inkillay", "urma", "kukuli", "warakusi", "wiñay wara", "qurissia", "kusirimay", "ninasisa", "achanqara", "lliwkilla", "amank'ay", "urpikusi", "shulla", "qhispisisa", "tamya", "mamadi", "bangaly", "seydou", "diarru", "fatounata", "ounar", "moussa", "djanko", "yousuf", "sekou", "fadina", "aminata"]

var torsos = [preload("res://avatars/body/Body_01.tscn"),preload("res://avatars/body/Body_02.tscn"),preload("res://avatars/body/Body_03.tscn"),preload("res://avatars/body/Body_04.tscn"),preload("res://avatars/body/Body_05.tscn"),preload("res://avatars/body/Body_06.tscn")]
var feet = [preload("res://avatars/feet/Feet_01.tscn"),preload("res://avatars/feet/Feet_02.tscn"),preload("res://avatars/feet/Feet_03.tscn"),preload("res://avatars/feet/Feet_04.tscn"),preload("res://avatars/feet/Feet_05.tscn"),preload("res://avatars/feet/Feet_06.tscn")]
var heads = [preload("res://avatars/head/Head_01.tscn"),preload("res://avatars/head/Head_02.tscn"),preload("res://avatars/head/Head_03.tscn"),preload("res://avatars/head/Head_04.tscn"),preload("res://avatars/head/Head_05.tscn"),preload("res://avatars/head/Head_06.tscn")]

# Player positions based on screen size

var qzuX = gameSize[0] / 4
var qzuY = gameSize[1] / 4
var xM = gameSize[0] / 16
var yM = gameSize[1] / 16

var playerPositions = {
	"player1": Vector2(qzuX - xM , qzuY - yM),
	"player2": Vector2(qzuX * 3 + xM , qzuY - yM),
	"player3": Vector2(qzuX - xM, qzuY * 3 + yM),
	"player4": Vector2(qzuX * 3 + xM, qzuY * 3 + yM)
}

var colors = {
	"red": {
		"value": Color(.77, .187, .247),
		"name": "Rojo"
		},
	"green": {
		"value": Color(.193, .94, .229),
		"name": "Verde"
		},
	"lightblue": {
		"value": Color(.211, .74, .74),
		"name": "Celeste"
		},
	"yellow": {
		"value": Color(1, 0.84375, 0),
		"name": "Amarillo"
		}
}

var cleanPlayerProps = {
	"player1": {
		"color": colors.green, 
		"texture": null,
		"head": null,
		"torso": null,
		"feet": null,
		"order": null,
		"screenPosition": null,
		"active": false,
		"games": null,
		"object": null,
		"name": null,
		"angle": -45,
		"wins": 0,
		"loses": 0,
	},
	"player2": {
		"color": colors.lightblue, 
		"texture": null,
		"head": null,
		"torso": null,
		"feet": null,
		"order": null,
		"screenPosition": null,
		"active": false,
		"games": null,
		"object": null,
		"name": null,
		"angle": 45,
		"wins": 0,
		"loses": 0
	},
	"player3": {
		"color": colors.yellow, 
		"texture": null,
		"head": null,
		"torso": null,
		"feet": null,
		"order": null,
		"screenPosition": null,
		"active": false,
		"games": null,
		"object": null,
		"name": null,
		"angle": 225,
		"wins": 0,
		"loses": 0
	},
	"player4": {
		"color": colors.red, 
		"texture": null,
		"head": null,
		"torso": null,
		"feet": null,
		"order": null,
		"screenPosition": null,
		"active": false,
		"games": null,
		"object": null,
		"name": null,
		"angle": 135,
		"wins": 0,
		"loses": 0
	}
}

var playerProps = cleanPlayerProps.duplicate(true)

var miniGames = {
	"turtle": {
		"time": 10,
		"scene": "res://minigames/TurtleCrossing.tscn",
		"tile": null,
		"name": "Cruza la tortuga"
	},
	"dog": {
		"time": 5,
		"scene": "res://minigames/TableDog.tscn",
		"tile": null,
		"name": "Surfea el perro"		
	},
	"sing": {
		"time": 5,
		"scene": "res://minigames/SingingTile.tscn",
		"tile": null,
		"name": "Canta la baldosa"
	},
	"crab": {
		"time": 8,
		"scene": "res://minigames/CrabWalk.tscn",
		"tile": null,
		"name": "Camina el cangrejo"
	},
	"flies": {
		"time": 5,
		"scene": "res://minigames/EspantaMoscas.tscn",
		"tile": null,
		"name": "Espanta las moscas"
	},
	"silbon": {
		"time": 6,
		"scene": "res://minigames/EspantaSilbon.tscn",
		"tile": null,
		"name": "Ahuyenta al silbon"
	},
	"foca": {
		"time": 5,
		"scene": "res://minigames/FocaPelota.tscn",
		"tile": null,
		"name": "Rebota la pelota"
	},
	"pinchapeces": {
		"time": 8,
		"scene": "res://minigames/PinchaPeces.tscn",
		"tile": null,
		"name": "Pincha los peces"
	},
	"disparaflecha": {
		"time": 6,
		"scene": "res://minigames/DisparaFlecha.tscn",
		"tile": null,
		"name": "Dispara la flecha"
	},
	"cosascayendo": {
		"time": 5,
		"scene": "res://minigames/CosasCayendo.tscn",
		"tile": null,
		"name": "Recoge el reciclaje"
	}
}

var currentMiniGames = miniGames.duplicate(true)
var playerItems = []
var playersOrder = []
var transitionMessage = "Put some text in the scene"
var nextScene = "res://Main.tscn"
var transitionType = "avatar"

func activePlayers():
	return Utils.getActivePlayers()

func nextScene(message, scene):
	transitionMessage = message
	nextScene = scene
	get_tree().change_scene("res://TransitionScene.gd")
	
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with(".") and file.ends_with(".png"):
            files.append(file)

    dir.list_dir_end()

    return files