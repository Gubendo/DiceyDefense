extends Node

const SAVE_FILE = "user://save_file.save"
var base_data: Dictionary = {
	"current_wave": 0,
	"nexus_hp": 50,
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

func _process(delta: float) -> void:
	pass
 
func save_game() -> void:
	var save_game: File = File.new()
	save_game.open(SAVE_FILE, File.WRITE)
	save_game.store_var(game_data)
	save_game.close()
	
func load_game() -> void:
	var save_game: File = File.new()
	if save_game.file_exists(SAVE_FILE):
		save_game.open(SAVE_FILE, File.READ)
		game_data = save_game.get_var()
		save_game.close()
	
	# HARDCODE ICI POUR CHEAT 
	game_data["nexus_hp"] = 1
		
func reset_save() -> void:
	game_data = base_data
	save_game()
