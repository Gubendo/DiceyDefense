extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Bourreau"

func special():
	print("BOURREAU : J'exec")
	if float(target.currentHP) / float(target.baseHP) <= stats[level]["exec"]:
		target.destroy()
	else:
		target.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value):
	level = 1
	
func update_tooltip():
	update_stats()
	tooltipText.text = "".format([currentStats[0], currentStats[1]])

func select_enemy():
	var progress_array = []
	var exec_array = []
	for i in enemies_in_range:
		if float(i.currentHP) / float(i.baseHP) <= stats[level]["exec"]:
			exec_array.append(i.progress)
		progress_array.append(i.progress)
	var max_progress
	var max_enemy
	if len(exec_array) == 0:
		max_progress = progress_array.max()
		max_enemy = progress_array.find(max_progress)
	else:
		max_progress = exec_array.max()
		max_enemy = exec_array.find(max_progress)
	target = enemies_in_range[max_enemy]
