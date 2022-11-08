extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Mage"

func special() -> void:
	print("MAGE : Je tire une boule de givre")
	target.apply_slow(0.5, 2)
	#target.take_dmg(stats[level]["damage"])

func update_level(value: int) -> void:
	level = value / 5
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts et réduit la vitesse de déplacement des ennemis toutes les {1} secondes".format([currentStats[0], currentStats[1]])
