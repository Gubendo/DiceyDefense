extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Colosse"

func special() -> void:
	print("COLOSSE : Je frappe tous les ennemis")
	for enemy in get_all_enemies():
		enemy.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value: int) -> void:
	level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de défense ultime qui inflige {0} points de dégâts \
à l'intégralité des ennemis toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func start_wave() -> void:
	atkReady = false
	await get_tree().create_timer(stats[level]["cooldown"]).timeout
	atkReady = true

# TROUVER UN MOYEN PLUS PROPRE DE DISABLE LA RANGE

func update_stats() -> void:
	super.update_stats()
	rangeSprite.modulate.a = 0
	
func enable_tooltip() -> void:
	super.enable_tooltip()
	rangeSprite.modulate.a = 0

