extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Archer"

func special() -> void:
	print("Je tire une flèche")
	if target != null:
		target.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value: int) -> void:
	#level = value / 2
	level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])

