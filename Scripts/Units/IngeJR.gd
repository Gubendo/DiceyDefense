extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "IngeJR"

func special() -> void:
	print("INGENIEUR JUNIOR : Ma catapulte tire")
	for enemy in get_all_enemies():
		if abs(target.position.distance_to(enemy.position)) < stats[level]["aoe"]:
			enemy.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value: int) -> void:
	level = 1

func activate() -> void:
	unit.visible = false
	disable_tooltip()
	
	unit = get_node("Catapulte")
	button = get_node("Catapulte/Activate")
	unitHover= get_node("Catapulte/Hover")
	unit.visible = true
	connect_signals()
	
	super.activate()


func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit une catapulte infligeant \
{0} points de dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])