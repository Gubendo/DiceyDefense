extends Node

var hand: Array = [1, 2, 3, 4, 5]
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var current_wave: int = 0
var enemies_in_wave: int = 0
var waveStarted: bool = false

var nexus_hp = 1

var save_system = SaveSystem

@onready var king_anim = $King/KingAnimation

func _ready() -> void:
	rng.randomize()
	connect_signals()
	load_gamestate()
	
func connect_signals() -> void:
	$King/Button.pressed.connect(on_king_pressed)
	$King/Button.mouse_entered.connect(enable_tooltip)
	$King/Button.mouse_exited.connect(disable_tooltip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waveStarted and enemies_in_wave == 0:
		print("FIN DE VAGUE")
		waveStarted = false
		save_gamestate()
		king_anim.play("join_city")
		await king_anim.animation_finished
		update_phase()


func _on_ui_roll(unfrozen: Array) -> void:
	
	var unfrozen_id: Array = []
	for i in range(len(unfrozen)):
		unfrozen_id.append((str(unfrozen[i].name).right(1)).to_int() - 1)
	for i in range(5):
		if i in unfrozen_id:
			hand[i] = rng.randi_range(1, 6)
	$YamsManager.calcul_hand(hand)
	$UI.update_hand(hand)
	if king_anim != null and not king_anim.is_playing():
		king_anim.play("roll_dice")
	
	for unit in $Units.get_children():
		if !unit.activated : 
			unit.update_level($YamsManager.combinaisons[GameData.unit_data[unit.name]["value"]][0])

func update_phase() -> void:
	if(waveStarted): king_anim.play("leave_city")
	$UI.update_phase(waveStarted, current_wave)
	for unit in $Units.get_children():
		if !unit.activated : 
			unit.visible = !waveStarted
			unit.button.disabled = waveStarted
			unit.sleeping = waveStarted
		else:
			unit.turn(1)
			unit.start_wave()
			
	for temp in $Temporary.get_children():
		temp.queue_free()
	
### Gestion de vagues

func start_next_wave() -> void:
	var wave_data: Array = retrieve_wave_data()
	enemies_in_wave = 0
	for group in wave_data:
		enemies_in_wave += group[0]
	waveStarted = true
	update_phase()
	$UI.text_animation.play("wavestart")
	await get_tree().create_timer(2.4).timeout
	$UI.text_animation.play("RESET")
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
			$KingsRoad.add_child(new_enemy, true)
			await get_tree().create_timer(group[2]).timeout
		await get_tree().create_timer(group[3]).timeout
		
func on_enemy_death(nexus_dmg: float) -> void:
	
	if nexus_dmg != 0:
		# ptite animation
		nexus_hp -= nexus_dmg
		if nexus_hp <= 0:
			nexus_hp = 0
			game_over()
		$UI.update_health(nexus_hp)
	enemies_in_wave -= 1

func game_over() -> void:
	Engine.set_time_scale(1.0)
	$UI.game_over()
	$Decor/Fire.visible = true
	for fire in $Decor/Fire.get_children():
		fire.get_node("Sprite2d").frame = rng.randi_range(0, 6)
		fire.get_node("Sprite2d").playing = true
	for enemy in $KingsRoad.get_children(): # DANSE
		enemy.dead = true
		enemy.animation_player.play("dance")
		enemy.health_bar.visible = false
	for unit in $Units.get_children(): # CRI D'HORREUR
		if unit.activated : unit.queue_free()
		

func load_gamestate() -> void:
	save_system.load_game()
	
	nexus_hp = save_system.game_data["nexus_hp"]
	current_wave = save_system.game_data["current_wave"]
	
	$UI.update_health(nexus_hp)
	$UI.waveNumber.text = "Prochaine vague : " + str(current_wave + 1) + "/13"
	
	for unit in $Units.get_children():
		var unit_data: Dictionary = save_system.game_data[unit.unitName]
		if unit_data["level"] == 0:
			unit.queue_free()
		elif unit_data["level"] > 0:
			unit.on_activate()
			unit.button.modulate = Color(1, 1, 1)
			unit.button.disabled = true
			unit.activated = true
			unit.rangeSprite.modulate.a = 0
			unit.level = unit_data["level"]
			unit.damage_dealt = unit_data["damage"]
			unit.update_tooltip()
			
			unit.unit_sprite.visible = true
			unit.button.modulate.a = 0
			unit.idle_anim()
			unit.disable_tooltip()
			
func save_gamestate() -> void:
	save_system.game_data["nexus_hp"] = nexus_hp
	save_system.game_data["current_wave"] = current_wave
	for unit in $Units.get_children():
		if unit.activated : 
			save_system.game_data[unit.unitName]["damage"] = unit.damage_dealt
	save_system.save_game()
	

func on_king_pressed() -> void:
	if $UI.coupsRestant > 0:
		$UI.press_roll()
	enable_tooltip()

func enable_tooltip() -> void:
	if not $King/Button.is_disabled():
		$King/CanvasLayer/Tooltip.visible = true
		$King/Hover.visible = true
		var coups: int = $UI.coupsRestant
		if coups == 0:
			$King/CanvasLayer/Tooltip/Description.text = "Il protège avec intêret son royaume en \
utilisant le pouvoir des reliques sacrées\n
[color=c8c8c8](Aucun lancer restant)"
		elif coups == 1:
			$King/CanvasLayer/Tooltip/Description.text = "Il protège avec intêret son royaume en \
utilisant le pouvoir des reliques sacrées\n
[color=c8c8c8](1 lancer restant)"
		else:
			$King/CanvasLayer/Tooltip/Description.text = "Il protège avec intêret son royaume en \
utilisant le pouvoir des reliques sacrées\n
[color=c8c8c8]({0} lancers restant)".format([$UI.coupsRestant])

func disable_tooltip() -> void:
	$King/CanvasLayer/Tooltip.visible = false
	$King/Hover.visible = false
