extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Colosse"

func special():
	print("COLOSSE : Je frappe tous les ennemis")
	var enemies = get_tree().get_root().get_node("Main/KingsRoad").get_children()
	for enemy in enemies:
		enemy.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value):
	level = 1
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité de défense ultime qui inflige {0} points de dégâts \
à l'intégralité des ennemis toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func start_wave():
	atkReady = false
	await get_tree().create_timer(stats[level]["cooldown"]).timeout
	atkReady = true

# TROUVER UN MOYEN PLUS PROPRE DE DISABLE LA RANGE

func update_stats():
	super.update_stats()
	rangeSprite.modulate.a = 0
	
func enable_tooltip():
	super.enable_tooltip()
	rangeSprite.modulate.a = 0

