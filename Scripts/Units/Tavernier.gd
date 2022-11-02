extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Tavernier"

func special():
	print("TAVERNIER : Je buff")

func update_level(value):
	level= 0
	
func update_tooltip():
	update_stats()
	tooltipText.text = "".format([currentStats[0], currentStats[1]])
