extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Loup"

func special():
	print("Je graille un coup")

func update_level(value):
	level = 0
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Animal qui mord un ennemi toutes les {0} secondes et lui \
inflige un saignement pendant {1} secondes".format([currentStats[1], currentStats[1]])
