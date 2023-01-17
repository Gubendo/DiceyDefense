extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Loup"

func special() -> void:
	if attack_target != null:
		print("LOUP : Je graille un coup")
		attack_target.apply_bleed(stats[level]["bleed"], stats[level]["duration"], stats[level]["freq"])

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Animal qui mord un ennemi toutes les {0} secondes, provoquant \
un saignement. 
Le saignement inflige {1} points de dégâts toutes les {2} secondes \
pendant {3} secondes".format([currentStats[3], currentStats[0], currentStats[1], currentStats[2]])
