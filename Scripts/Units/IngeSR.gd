extends "res://Scripts/Units/unit.gd"

@onready var caillouTemp = load("res://Scenes/Projectiles/caillou.tscn")
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "IngeSR"

func special() -> void:
	if attack_target != null:
		print("INGENIEUR SENIOR : Mon trébuchet tire")
		shoot_caillou()

func update_level(value: int) -> void:
	level = 1

func activate() -> void:
	unit.visible = false
	disable_tooltip()
	
	unit = $Trebuchet
	unit_sprite = $Trebuchet/Sprite
	button = $Trebuchet/Activate
	unitHover= $Trebuchet/Hover
	unit.visible = true
	connect_signals()
	
	super.activate()

func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit un trébuchet infligeant \
{0} points de dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func shoot_caillou() -> void:
	var caillou = caillouTemp.instantiate()
	var start: Vector2 = $Trebuchet/ShootPos.global_position
	caillou.position = start
	caillou.start_pos = start
	caillou.middle_pos = Vector2(start.x + (attack_target.global_position.x - start.x)/2,\
	(start.y + (attack_target.global_position.y - start.y)/2) - 600)
	caillou.end_pos = attack_target.global_position
	caillou.target = attack_target
	caillou.aoe_range = stats[level]["aoe"]
	caillou.damage = stats[level]["damage"] * buff_dmg
	caillou.speed_factor = 0.7
	get_tree().get_root().get_node("Main/Temporary").add_child(caillou)

