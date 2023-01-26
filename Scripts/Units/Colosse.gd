extends "res://Scripts/Units/unit.gd"

@onready var shockwaveTemp: Resource = load("res://Scenes/Projectiles/shockwave.tscn")
var shockwave_left: Variant
var shockwave_right: Variant
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Colosse"

func special() -> void:
	print("COLOSSE : Je frappe tous les ennemis")
	start_shockwave()
	#for enemy in get_all_enemies():
	#	enemy.take_dmg(stats[level]["damage"] * buff_dmg)

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de défense ultime qui inflige {0} points de dégâts \
à l'intégralité des ennemis toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func start_wave() -> void:
	atkReady = false
	await get_tree().create_timer(stats[level]["cooldown"]).timeout
	atkReady = true

func update_stats() -> void:
	super.update_stats()
	rangeSprite.modulate.a = 0
	
func enable_tooltip() -> void:
	super.enable_tooltip()
	rangeSprite.modulate.a = 0

func on_activate() -> void:
	update_tooltip_size(35)
	
func start_shockwave() -> void:
	shockwave_left = shockwaveTemp.instantiate()
	$/root/Main/KingsRoad.add_child(shockwave_left, true)
	shockwave_left.progress = $/root/Main/KingsRoad.curve.get_closest_offset($/root/Main/KingsRoad.curve.get_point_position(6))
	shockwave_left.damage = stats[level]["damage"] * buff_dmg
	shockwave_left.speed = 100
	shockwave_left.direction = 1
	$/root/Main/Temporary.add_child(shockwave_left)
	
	shockwave_right = shockwaveTemp.instantiate()
	$/root/Main/KingsRoad.add_child(shockwave_right, true)
	shockwave_right.progress = $/root/Main/KingsRoad.curve.get_closest_offset($/root/Main/KingsRoad.curve.get_point_position(6))
	shockwave_right.damage = stats[level]["damage"] * buff_dmg
	shockwave_right.speed = 100
	shockwave_right.direction = -1
	$/root/Main/Temporary.add_child(shockwave_right)
	shockwave_right.burst()
