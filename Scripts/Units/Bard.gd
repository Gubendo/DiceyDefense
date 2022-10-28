extends "res://Scripts/Units/unit.gd"

@onready var root_node = get_tree().get_root()
var rng = RandomNumberGenerator.new()

var targets = []
# Called when the node enters the scene tree for the first time.
func _init():
	unitName = "Bard"
	rng.randomize()

func special():
	print("BARDE : Je joue de la musique sur " + str(targets))
	for unit in targets:
		unit.buff_as = stats[level]["buff"]
		unit.button.modulate = Color(0.3, 0, 0.3)
	await get_tree().create_timer(stats[level]["duration"]).timeout
	for unit in targets:
		unit.buff_as = 1
		unit.button.modulate = Color(1, 1, 1)

func update_level(value):
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip():
	update_stats()
	tooltipText.text = "Unité de soutien qui chante \
toutes les {0} secondes".format([currentStats[1]])

func _process(delta):
	if activated and root_node.get_node("Main").waveStarted:
		if atkReady:
			select_target()
			attack()
	else:
		target = null

func select_target():
	var trueR = range.get_node("CollisionShape2d").shape.radius * (stats[level]["range"] + 1) * scale.x
	var potential_targets = []
	targets = []
	for unit in root_node.get_node("Main/Units").get_children():
		if position.distance_to(unit.position) < trueR and unit != self and unit.activated:
			potential_targets.append(unit)
			
	var nb_targets = min(potential_targets.size(), stats[level]["target"])
	for i in range(nb_targets):
		var rand_index = rng.randi() % potential_targets.size()
		targets.append(potential_targets[rand_index])
		potential_targets.erase(potential_targets[rand_index])
		

