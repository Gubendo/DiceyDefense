extends "res://Scripts/Units/unit.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Loup"

func special() -> void:
	print("LOUP : Je graille un coup")
	if attack_target != null:
		$AudioStreamPlayer2D.play()
		attack_target.apply_bleed(stats[level]["bleed"], stats[level]["duration"], stats[level]["freq"])
	else:
		select_enemy()
		attack_target = target
		if attack_target != null: 
			attack_target.apply_bleed(stats[level]["bleed"], stats[level]["duration"], stats[level]["freq"])
			$AudioStreamPlayer2D.play()

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Animal qui mord un ennemi toutes les {0} secondes, provoquant \
un saignement. 
Le saignement inflige {1} points de dégâts toutes les {2} secondes \
pendant {3} secondes\n
[color=dbdbdb]Les saignements successifs s'accumulent".format([currentStats[3], currentStats[0], currentStats[1], currentStats[2]])

func on_activate() -> void:
	update_tooltip_size(65)
	if level == 5:
		$Unit/Sprite.texture = load("res://Animations/Loup/corgi-max.png")
