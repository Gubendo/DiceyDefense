extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "IngeSR"

func special():
	print("INGENIEUR JUNIOR : Mon trébuchet tire")
	var enemies = get_tree().get_root().get_node("Main/KingsRoad").get_children()
	for enemy in enemies:
		if abs(target.position.distance_to(enemy.position)) < stats[level]["aoe"]:
			enemy.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value):
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip():
	update_stats()
	tooltipText.text = "".format([currentStats[0], currentStats[1]])
