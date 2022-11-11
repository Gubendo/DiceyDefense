extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Tavernier"

func special() -> void:
	print("TAVERNIER : Je buff")

func activate() -> void:
	super.activate()
	buff_everyone()
	
func update_level(value: int) -> void:
	level = 1

func buff_everyone() -> void:
	for unit in get_all_allies():
		unit.buff_dmg *= stats[level]["buff_dmg"]

func _process(delta: float) -> void:
	pass
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui multiplie les dégâts des troupes \
alliées par {0} de manière permanente".format([currentStats[0]])
