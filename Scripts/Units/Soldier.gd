extends "res://Scripts/Units/unit.gd"

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Soldier"
	
func special() -> void:
	print("PAYSAN : Je donne un coup d'épée")
	if attack_target != null: 
		attack_target.take_dmg(stats[level]["damage"] * buff_dmg)
		damage_dealt += stats[level]["damage"] * buff_dmg

func update_level(value: int) -> void:
	if value == 0: level = 0
	else: level = 3
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque au corps à corps qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])
