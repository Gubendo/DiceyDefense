extends "res://Scripts/Units/unit.gd"

@onready var caillouTemp = load("res://Scenes/Projectiles/caillou.tscn")
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "IngeJR"

func special() -> void:
	print("INGENIEUR JUNIOR : Ma catapulte tire")
	shoot_caillou()

func update_level(value: int) -> void:
	level = 1

func activate() -> void:
	unit.visible = false
	disable_tooltip()
	
	unit = get_node("Catapulte")
	button = get_node("Catapulte/Activate")
	unitHover= get_node("Catapulte/Hover")
	unit.visible = true
	connect_signals()
	
	super.activate()


func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui construit une catapulte infligeant \
{0} points de dégâts en zone toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func shoot_caillou() -> void:
	var caillou = caillouTemp.instantiate()
	caillou.position = position
	caillou.start_pos = position
	var start: Vector2 = get_node("Catapulte/ShootPos").global_position
	caillou.middle_pos = Vector2(start.x + (target.position.x - start.x)/2, start.y - 50)
	caillou.end_pos = target.position
	caillou.target = target
	caillou.aoe_range = stats[level]["aoe"]
	caillou.damage = stats[level]["damage"] * buff_dmg
	caillou.speed_factor = 3
	get_tree().get_root().get_node("Main/Temporary").add_child(caillou)
