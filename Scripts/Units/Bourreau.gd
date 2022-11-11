extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Bourreau"

func special() -> void:
	if float(target.currentHP) / float(target.baseHP) <= stats[level]["exec"]/100:
		target.destroy()
		print("BOURREAU : J'exec")
	else:
		target.take_dmg(stats[level]["damage"] * buff_dmg)
		print("BOURREAU : Je tranche")

func update_level(value: int) -> void:
	level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts toutes les {1} secondes. 
Si la cible possède moins de {2} pcent de ses PV, \
elle est executée".format([currentStats[0], currentStats[1], currentStats[2]])

func select_enemy() -> void:
	var progress_array: Array = []
	var exec_array: Array = []
	for i in enemies_in_range:
		if float(i.currentHP) / float(i.baseHP) <= stats[level]["exec"]/100:
			exec_array.append(i.progress)
		progress_array.append(i.progress)
	var max_progress: float
	var max_enemy: int
	if len(exec_array) == 0:
		max_progress = progress_array.max()
		max_enemy = progress_array.find(max_progress)
	else:
		max_progress = exec_array.max()
		max_enemy = exec_array.find(max_progress)
	target = enemies_in_range[max_enemy]
