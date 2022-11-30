extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Bourreau"

func special() -> void:
	if attack_target != null:
		attack_target.take_dmg(stats[level]["damage"] * buff_dmg)
		print("BOURREAU : Je tranche")
		
func execute() -> void:
	if attack_target != null:
		attack_target.destroy()
		print("BOURREAU : J'execute")
	
func attack() -> void:
	atkReady = false
	if float(target.currentHP) / float(target.baseHP) <= float(stats[level]["exec"])/100:
		exec_anim()
	else:
		attack_anim()
	await get_tree().create_timer(stats[level]["cooldown"] / buff_as).timeout
	atkReady = true
	
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
		if float(i.currentHP) / float(i.baseHP) <= float(stats[level]["exec"])/100:
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
		
func exec_anim() -> void:
	idling = false
	lastAttack.start(last_attack_time)
	attack_target = target
	
	var anim: float = animation_player.get_animation("execute").length / animation_player.playback_speed
	var attsp: float = stats[level]["cooldown"] / buff_as
	#animation_player.playback_speed = 1 / (attsp / animation_player.get_animation("attack").length)
	if anim > attsp:
		animation_player.playback_speed = (anim / attsp)*1.1
	animation_player.play("execute")
