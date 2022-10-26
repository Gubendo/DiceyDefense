extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Archer"

func special():
	print("Je tire une flèche")
	target.take_dmg(stats[level]["damage"])

func update_level(value):
	level = value / 2
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])

