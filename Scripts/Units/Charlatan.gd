extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Charlatan"

func special():
	pass

func activate():
	super.activate()
	var ui = get_tree().get_root().get_node("Main/UI")
	ui.nbRolls += stats[level]["bonus_roll"]

func update_level(value):
	if value < 20: level = 1
	else: level = 2
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité inactive pendant les vagues d'ennemis et qui permet \
d'obtenir {0} lancers de dés supplémentaires".format([currentStats[0]])
	
func _process(delta):
	pass
