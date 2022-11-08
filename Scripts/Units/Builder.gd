extends "res://Scripts/Units/unit.gd"

@onready var barricadeTemp = load("res://Scenes/Buildings/Barricade.tscn")
var barricade
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Builder"

func special() -> void:
	pass

func activate() -> void:
	super.activate()
	build_barricade()

func update_level(value: int) -> void:
	level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit une barricade possédant \
{0} points de vie et infligeant {1} points de dégâts aux unités qui \
l'attaquent".format([currentStats[0], currentStats[1]])
	
func _process(delta: float) -> void:
	pass

func start_wave() -> void:
	repair_barricade()

func repair_barricade() -> void:
	if barricade and barricade.baseHP != barricade.currentHP:
		print("BUILDER : Je répare ma barricade")
		barricade.repair()

func build_barricade() -> void:
	print("BUILDER : Je construis une barricade")
	barricade = barricadeTemp.instantiate()
	get_tree().get_root().add_child(barricade)
	barricade.position = Vector2(-312, -250)
	barricade.baseHP = stats[level]["health"]
	barricade.thorns = stats[level]["damage"]
	barricade.init()
