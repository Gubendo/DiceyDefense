extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Paladin"

func special():
	print("Je donne un coup de marteau")

func update_level(value):
	level = 0
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité d'attaque au corps à corps qui inflige {0} points de \
dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])
