extends Node

var hand = [1, 2, 3, 4, 5]
var rng = RandomNumberGenerator.new()

var current_wave = 0
var enemies_in_wave = 0
var waveStarted = false

func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if waveStarted and enemies_in_wave == 0:
		print("FIN DE VAGUE")
		waveStarted = false
		update_phase()


func _on_ui_roll(unfrozen):
	var unfrozen_id = []
	for i in range(len(unfrozen)):
		unfrozen_id.append((str(unfrozen[i].name).right(1)).to_int() - 1)
	for i in range(5):
		if i in unfrozen_id:
			hand[i] = rng.randi_range(1, 6)
	get_node("YamsManager").calcul_hand(hand)
	get_node("UI").update_hand(hand)
	
	for node in get_node("Units").get_children():
		if !node.activated : 
			node.update_level(get_node("YamsManager").combinaisons[GameData.unit_data[node.name]["value"]])

func update_phase():
	get_node("UI").update_phase(waveStarted)
	for unit in get_node("Units").get_children():
		if !unit.activated : 
			unit.button.disabled = waveStarted
			unit.sleeping = waveStarted
		else:
			unit.turn(1)
	
### Gestion de vagues

func start_next_wave():
	var wave_data = retrieve_wave_data()
	enemies_in_wave = wave_data.size()
	waveStarted = true
	update_phase()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)
	
	
func retrieve_wave_data():
	var wave_data = GameData.wave_data[current_wave]
	if current_wave < GameData.wave_data.size() - 1:
		current_wave += 1
	return wave_data
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.death.connect(on_enemy_death)
		get_node("KingsRoad").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout
		
func on_enemy_death():
	enemies_in_wave -= 1
