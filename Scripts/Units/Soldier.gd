extends "res://Scripts/Units/unit.gd"

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Soldier"
	
func special() -> void:
	print("PAYSAN : Je donne un coup d'épée")
	if attack_target != null: 
		$AudioStreamPlayer2D.play()
		attack_target.take_dmg(stats[level]["damage"] * buff_dmg)
		damage_dealt += stats[level]["damage"] * buff_dmg
	else:
		select_enemy()
		attack_target = target
		if attack_target != null: 
			$AudioStreamPlayer2D.play()
			attack_target.take_dmg(stats[level]["damage"] * buff_dmg)
			damage_dealt += stats[level]["damage"] * buff_dmg

func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque au corps à corps qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func on_activate() -> void:
	update_tooltip_size(30)
	if level == 5:
		$Unit/Sprite.texture = load("res://Animations/Soldier/soldier-max.png")
