extends "res://Scripts/Units/unit.gd"

@onready var arrowTemp: Resource = load("res://Scenes/Projectiles/arrow.tscn")
var arrow: Variant
var start: Vector2
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Archer"
	ranged = true

func special() -> void:
	print("ARCHER : Je tire une flèche")
	if attack_target != null:
		shoot_arrow()
		$AudioStreamPlayer2D.play()
	else:
		select_enemy()
		attack_target = target
		if attack_target != null: 
			shoot_arrow()
			$AudioStreamPlayer2D.play()

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func shoot_arrow() -> void:
	arrow = arrowTemp.instantiate()
	start = $Unit/ShootPos.global_position
	arrow.position = start
	arrow.start_pos = start
	arrow.middle_pos = Vector2(start.x + (attack_target.global_position.x - start.x)/2,\
	(start.y + (attack_target.global_position.y - start.y)/2) - 10)
	arrow.end_pos = attack_target.global_position
	arrow.target = attack_target
	arrow.damage = stats[level]["damage"] * buff_dmg
	arrow.speed_factor = 4
	$/root/Main/Temporary.add_child(arrow)
	

func on_activate() -> void:
	update_tooltip_size(30)
	if level == 5:
		$Unit/Sprite.texture = load("res://Animations/Archer/archer-max.png")

