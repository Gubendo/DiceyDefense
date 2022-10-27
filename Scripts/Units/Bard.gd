extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Bard"

func special():
	print("Je joue de la musique")

func update_level(value):
	level = 0
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité de soutien qui chante \
toutes les {0} secondes".format([currentStats[1]])
