extends "res://Scripts/Units/unit.gd"

@onready var barricadeTemp = load("res://Scenes/Buildings/Barricade.tscn")
var barricade
# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Builder"

func special():
	pass

func activate():
	super.activate()
	build_barricade()

func update_level(value):
	level = 1
	
func update_tooltip():
	update_stats()
	tooltipText.text = "".format([currentStats[0], currentStats[1]])
	
func _process(delta):
	pass

func start_wave():
	repair_barricade()

func repair_barricade():
	if barricade and barricade.baseHP != barricade.currentHP:
		print("BUILDER : Je répare")
		barricade.repair()

func build_barricade():
	print("BUILDER : Je construis une barricade")
	barricade = barricadeTemp.instantiate()
	get_tree().get_root().add_child(barricade)
	barricade.position = Vector2(-312, -250)
	barricade.baseHP = stats[level]["health"]
	barricade.thorns = stats[level]["damage"]
	barricade.init()
