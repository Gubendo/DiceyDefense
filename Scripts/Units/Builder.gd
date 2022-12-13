extends "res://Scripts/Units/unit.gd"

@onready var barricadeTemp = load("res://Scenes/Buildings/Barricade.tscn")
var barricades: Array = []
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Builder"

func special() -> void:
	pass

func on_activate() -> void:
	print("BUILDER : Je construis des barricades")
	if stats[level]["nb"] == 1: build_barricade(Vector2(-162, -150))
	if stats[level]["nb"] == 2: 
		build_barricade(Vector2(-174, -150))
		build_barricade(Vector2(-150, -150))

func update_level(value: int) -> void:
	level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit {0} barricades possédant \
{1} points de vie et infligeant {2} points de dégâts aux unités qui \
les attaquent".format([currentStats[2], currentStats[0], currentStats[1]])
	
func _process(delta: float) -> void:
	pass

func start_wave() -> void:
	repair_barricade()

func repair_barricade() -> void:
	if barricades.size() != 0:
		for barricade in barricades:
			if barricade.baseHP != barricade.currentHP:
				print("BUILDER : Je répare ma barricade")
				barricade.repair()

func build_barricade(b_position: Vector2) -> void:
	var barricade = barricadeTemp.instantiate()
	get_tree().get_root().get_node("Main").add_child(barricade)
	get_tree().get_root().get_node("Main").move_child(barricade, 4)
	barricade.position = b_position
	barricade.baseHP = stats[level]["health"]
	barricade.thorns = stats[level]["damage"]
	barricade.init()
	barricades.append(barricade)
