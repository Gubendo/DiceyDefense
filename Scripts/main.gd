extends Node

var hand: Array = [1, 2, 3, 4, 5]
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var current_wave: int = 0
var enemies_in_wave: int = 0
var waveStarted: bool = false

var nexus_hp = 50

func _ready() -> void:
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waveStarted and enemies_in_wave == 0:
		print("FIN DE VAGUE")
		waveStarted = false
		await get_tree().create_timer(1.5).timeout
		update_phase()


func _on_ui_roll(unfrozen: Array) -> void:
	var unfrozen_id: Array = []
	for i in range(len(unfrozen)):
		unfrozen_id.append((str(unfrozen[i].name).right(1)).to_int() - 1)
	for i in range(5):
		if i in unfrozen_id:
			hand[i] = rng.randi_range(1, 6)
	get_node("YamsManager").calcul_hand(hand)
	get_node("UI").update_hand(hand)
	
	for unit in get_node("Units").get_children():
		if !unit.activated : 
			unit.update_level(get_node("YamsManager").combinaisons[GameData.unit_data[unit.name]["value"]][0])

func update_phase() -> void:
	get_node("UI").update_phase(waveStarted, current_wave)
	for unit in get_node("Units").get_children():
		if !unit.activated : 
			unit.visible = !waveStarted
			unit.button.disabled = waveStarted
			unit.sleeping = waveStarted
		else:
			unit.turn(1)
			unit.start_wave()
			
	for temp in get_node("Temporary").get_children():
		temp.queue_free()
	
### Gestion de vagues

func start_next_wave() -> void:
	var wave_data: Array = retrieve_wave_data()
	enemies_in_wave = 0
	for group in wave_data:
		enemies_in_wave += group[0]
	waveStarted = true
	update_phase()
	await get_tree().create_timer(1.5).timeout
	spawn_enemies(wave_data)
	
	
func retrieve_wave_data() -> Array:
	var wave_data: Array
	if current_wave < GameData.wave_data.size() - 1:
		wave_data = GameData.wave_data[current_wave]
	else:
		wave_data = GameData.wave_data[GameData.wave_data.keys()[-1]]
	current_wave += 1
	return wave_data
	
func spawn_enemies(wave_data: Array) -> void:
	for group in wave_data:
		for i in range(group[0]):
			var new_enemy = load("res://Scenes/Enemies/" + group[1] + ".tscn").instantiate()
			new_enemy.death.connect(on_enemy_death)
			get_node("KingsRoad").add_child(new_enemy, true)
			await get_tree().create_timer(group[2]).timeout
		await get_tree().create_timer(group[3]).timeout
		
func on_enemy_death(nexus_dmg: float) -> void:
	nexus_hp -= nexus_dmg
	if nexus_dmg != 0:
		# ptite animation
		get_node("UI").update_health(nexus_hp)
	enemies_in_wave -= 1
