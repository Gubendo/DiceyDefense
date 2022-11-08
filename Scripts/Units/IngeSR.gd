extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "IngeSR"

func special() -> void:
	print("INGENIEUR JUNIOR : Mon trébuchet tire")
	for enemy in get_all_enemies():
		if abs(target.position.distance_to(enemy.position)) < stats[level]["aoe"]:
			enemy.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value: int) -> void:
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit un trébuchet infligeant \
{0} points de dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])
