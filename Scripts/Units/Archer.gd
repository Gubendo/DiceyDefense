extends "res://Scripts/Units/unit.gd"

@onready var arrowTemp = load("res://Scenes/Projectiles/arrow.tscn")
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Archer"
	ranged = true

func special() -> void:
	print("ARCHER : Je tire une flèche")
	if attack_target != null:
		shoot_arrow()

func update_level(value: int) -> void:
	#level = value / 2
	level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func shoot_arrow() -> void:
	var arrow = arrowTemp.instantiate()
	var start: Vector2 = $Unit/ShootPos.global_position
	arrow.position = start
	arrow.start_pos = start
	arrow.middle_pos = Vector2(start.x + (attack_target.global_position.x - start.x)/2,\
	(start.y + (attack_target.global_position.y - start.y)/2) - 10)
	arrow.end_pos = attack_target.global_position
	arrow.target = attack_target
	arrow.damage = stats[level]["damage"] * buff_dmg
	arrow.speed_factor = 4
	get_tree().get_root().get_node("Main/Temporary").add_child(arrow)

