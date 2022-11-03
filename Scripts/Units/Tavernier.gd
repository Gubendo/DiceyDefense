extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Tavernier"

func special():
	print("TAVERNIER : Je buff")

func activate():
	super.activate()
	buff_everyone()
	
func update_level(value):
	level = 1

func buff_everyone():
	for unit in get_tree().get_root().get_node("Main/Units").get_children():
		unit.buff_dmg = stats[level]["buff_dmg"]

func _process(delta):
	pass
	
func update_tooltip():
	update_stats()
	tooltipText.text = "".format([currentStats[0], currentStats[1]])
