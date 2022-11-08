extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Loup"

func special() -> void:
	print("LOUP : Je graille un coup")
	target.apply_bleed(10, 1, 0.5)

func update_level(value: int) -> void:
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Animal qui mord un ennemi toutes les {0} secondes et lui \
inflige un saignement pendant {1} secondes".format([currentStats[1], currentStats[1]])
