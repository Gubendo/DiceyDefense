extends "res://Scripts/Units/unit.gd"

@onready var root_node: Node = get_tree().get_root()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


var targets: Array = []
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Bard"
	rng.randomize()


func special() -> void:
	print("BARDE : Je joue de la musique sur " + str(targets))
	for unit in targets:
		unit.buff_as *= stats[level]["buff"]
		#unit.unit_sprite.modulate = Color(0.3, 0, 0.3)
	await get_tree().create_timer(stats[level]["duration"]).timeout
	for unit in targets:
		unit.buff_as /= stats[level]["buff"]
		#unit.unit_sprite.modulate = Color(1, 1, 1)

func update_level(value: int) -> void:
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui multiplie par {1} la vitesse d'attaque de {0} \
unités proches pendant {2} secondes toutes les {3} secondes\
".format([currentStats[0], currentStats[1], currentStats[2], currentStats[3]])

func _process(delta: float) -> void:
	if activated and root_node.get_node("Main").waveStarted:
		if atkReady:
			select_target()
			attack()
	else:
		target = null

func select_target() -> void:
	var trueR: float = range.get_node("CollisionShape2d").shape.radius * (stats[level]["range"] + 1) * scale.x
	var potential_targets: Array = []
	targets = []
	for unit in get_all_allies():
		if position.distance_to(unit.position) < trueR and unit != self and unit.activated:
			potential_targets.append(unit)
			
	var nb_targets = min(potential_targets.size(), stats[level]["target"])
	for i in range(nb_targets):
		var rand_index = rng.randi() % potential_targets.size()
		targets.append(potential_targets[rand_index])
		potential_targets.erase(potential_targets[rand_index])
		

