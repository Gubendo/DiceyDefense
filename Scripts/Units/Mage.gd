extends "res://Scripts/Units/unit.gd"

@onready var boltTemp: Resource = load("res://Scenes/Projectiles/frostbolt.tscn")
var bolt: Variant
var start: Vector2
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Mage"
	ranged = true

func special() -> void:
	if attack_target != null:
		print("MAGE : Je tire une boule de givre")
		shoot_frostbolt()
		$AudioStreamPlayer2D.play()

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque à distance qui inflige {0} points de \
dégâts et réduit la vitesse de déplacement de moitié pendant {1} secondes \
toutes les {2} secondes".format([currentStats[0], currentStats[1], currentStats[2]])

func shoot_frostbolt() -> void:
	bolt = boltTemp.instantiate()
	start = $Unit/ShootPos.global_position
	bolt.position = start
	bolt.start_pos = start
	bolt.middle_pos = Vector2(start.x + (attack_target.global_position.x - start.x)/2,\
	(start.y + (attack_target.global_position.y - start.y)/2))
	bolt.end_pos = attack_target.global_position
	bolt.target = attack_target
	bolt.damage = stats[level]["damage"] * buff_dmg
	bolt.slow_value = 0.5
	bolt.slow_duration = stats[level]["duration"]
	bolt.speed_factor = 4
	$/root/Main/Temporary.add_child(bolt)

func on_activate() -> void:
	if level == 5:
		$Unit/Sprite.texture = load("res://Animations/Mage/mage-max.png")
