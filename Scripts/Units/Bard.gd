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
	$AudioStreamPlayer2D.play()
	for unit in targets:
		unit.buff_as *= stats[level]["buff"]
		unit.status_player.play("buff")
	await get_tree().create_timer(stats[level]["duration"]).timeout
	for unit in targets:
		unit.buff_as /= stats[level]["buff"]
		unit.status_player.play("RESET")
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité de soutien qui multiplie par {1} la vitesse d'attaque de {0} \
unités proches pendant {2} secondes toutes les {3} secondes\
".format([currentStats[0], currentStats[1], currentStats[2], currentStats[3]])

func _process(_delta: float) -> void:
	if activated and root_node.get_node("Main").waveStarted:
		if atkReady:
			select_target()
			if targets.size() != 0:
				attack()
	else:
		target = null
		
	if activated and lastAttack.time_left <= 0 and !idling:
		idle_anim()

func select_target() -> void:
	var trueR: float = range_area.get_node("CollisionShape2d").shape.radius * (stats[level]["range"] + 1) * scale.x
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
		
func on_activate() -> void:
	if level == 5:
		$Unit/Sprite.texture = load("res://Animations/Bard/bard-max.png")
		

