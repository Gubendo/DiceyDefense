extends "res://Scripts/Units/unit.gd"

@onready var shockwaveTemp: Resource = load("res://Scenes/Projectiles/shockwave.tscn")
var shockwave_left: Variant
var shockwave_right: Variant
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Colosse"

func special() -> void:
	print("COLOSSE : J'envoie 2 shockwaves")
	start_shockwave()

	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de défense ultime qui inflige {0} points de dégâts \
à l'intégralité des ennemis terrestres toutes les {1} secondes".format([currentStats[0], currentStats[1]])

func start_wave() -> void:
	atkReady = false
	var wave: int = $/root/Main.current_wave
	await get_tree().create_timer(stats[level]["cooldown"]).timeout
	if wave == $/root/Main.current_wave:
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
	
	shockwave_right = shockwaveTemp.instantiate()
	$/root/Main/KingsRoad.add_child(shockwave_right, true)
	shockwave_right.progress = $/root/Main/KingsRoad.curve.get_closest_offset($/root/Main/KingsRoad.curve.get_point_position(6))
	shockwave_right.damage = stats[level]["damage"] * buff_dmg
	shockwave_right.speed = 100
	shockwave_right.direction = -1
	shockwave_right.burst()
