extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Paladin"

func special() -> void:
	
	if attack_target != null:
		print("PALADIN : Je donne un coup de marteau")
		attack_target.take_dmg(stats[level]["damage"] * buff_dmg)
		for enemy in get_all_enemies():
			if abs(attack_target.position.distance_to(enemy.position)) < stats[level]["aoe"] and attack_target != enemy:
				enemy.take_dmg(stats[level]["splash"] * buff_dmg)

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque au corps à corps qui inflige {0} points de \
dégâts toutes les {1} secondes. 
Les unités proches de la cible subissent {2} points de \
dégâts".format([currentStats[0], currentStats[1], currentStats[3]])
