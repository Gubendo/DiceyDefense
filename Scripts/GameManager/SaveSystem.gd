extends Node

var grille: Dictionary = {
	"total1": -1,
	"total2": -1,
	"total3": -1,
	"total4": -1,
	"total5": -1,
	"total6": -1,
	"brelan": -1,
	"carre": -1,
	"full": -1,
	"p_suite": -1,
	"g_suite": -1,
	"chance": -1,
	"yams": -1
}

var settings: Dictionary = {
	"fullscreen_on": false,
	"vsync_on": false,
	"brightness": 1,
	"glow": 0,
	"master_vol": 100,
	"music_vol": 100,
	"sfx_vol": 100, 
}

const SAVE_FILE = "user://save_file.save"
var base_data: Dictionary = {
	"current_wave": 0,
	"nexus_hp": 20,
	"grille": grille,
	"settings": settings,
	"Soldier": {
		"level": -1,
		"damage": 0
	},
	"Archer": {
		"level": -1,
		"damage": 0
	},
	"Loup": {
		"level": -1,
		"damage": 0
	},
	"Bard": {
		"level": -1,
		"damage": 0
	},
	"Mage": {
		"level": -1,
		"damage": 0
	},
	"Paladin": {
		"level": -1,
		"damage": 0
	},
	"Builder": {
		"level": -1,
		"damage": 0
	},
	"Bourreau": {
		"level": -1,
		"damage": 0
	},
	"Tavernier": {
		"level": -1,
		"damage": 0
	},
	"IngeJR": {
		"level": -1,
		"damage": 0
	},
	"IngeSR": {
		"level": -1,
		"damage": 0
	},
	"Charlatan": {
		"level": -1,
		"damage": 0
	},
	"Colosse": {
		"level": -1,
		"damage": 0
	}
}

var game_data: Dictionary = {}
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	game_data = base_data

func _process(_delta: float) -> void:
	pass
 
func save_game() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save_file.store_var(game_data)
	
func load_game() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
		game_data = save_file.get_var()
	
	# HARDCODE ICI POUR CHEAT
	
	game_data["nexus_hp"] = 1 
		
func reset_save() -> void:
	var current_settings: Dictionary = game_data["settings"]
	game_data = base_data
	game_data["settings"] = current_settings
	save_game()
