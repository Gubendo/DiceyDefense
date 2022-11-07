extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Paladin"

func special():
	print("PALADIN : Je donne un coup de marteau")
	var enemies = get_tree().get_root().get_node("Main/KingsRoad").get_children()
	target.take_dmg(stats[level]["damage"] * buff_dmg)
	for enemy in enemies:
		if abs(target.position.distance_to(enemy.position)) < stats[level]["aoe"] and target != enemy:
			enemy.take_dmg(stats[level]["splash"] * buff_dmg)

func update_level(value):
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité d'attaque au corps à corps qui inflige {0} points de \
dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])
