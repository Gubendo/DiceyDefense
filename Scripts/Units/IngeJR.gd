extends "res://Scripts/Units/unit.gd"

@onready var caillouTemp: Resource = load("res://Scenes/Projectiles/caillou.tscn")
var caillou: Variant
var start: Vector2
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "IngeJR"

func special() -> void:
	print("INGENIEUR JUNIOR : Ma catapulte tire")
	if attack_target != null:
		shoot_caillou()

func on_activate() -> void:
	unit.visible = false
	disable_tooltip()
	
	unit = $Catapulte
	unit_sprite = $Catapulte/Sprite
	button = $Catapulte/Activate
	unitHover = $Catapulte/Hover
	unit.visible = true
	connect_signals()


func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit une catapulte infligeant \
{0} points de dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func shoot_caillou() -> void:
	caillou = caillouTemp.instantiate()
	start = $Catapulte/ShootPos.global_position
	caillou.position = start
	caillou.start_pos = start
	caillou.middle_pos = Vector2(start.x + (attack_target.global_position.x - start.x)/2,\
	(start.y + (attack_target.global_position.y - start.y)/2) - 50)
	caillou.end_pos = attack_target.global_position
	caillou.target = attack_target
	caillou.aoe_range = stats[level]["aoe"]
	caillou.damage = stats[level]["damage"] * buff_dmg
	caillou.speed_factor = 3
	$/root/Main/Temporary.add_child(caillou)
