extends Node

var hand: Array = [1, 2, 3, 4, 5]
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var current_wave: int = 0
var enemies_in_wave: int = 0
var waveStarted: bool = false
var playing: bool = true

var nexus_hp: int

var save_system = SaveSystem
var tuto_step: int

@onready var king_anim = $King/KingAnimation
var shield_upgrade: Resource = preload("res://Sprites/UI/shield-upgrade.png")

@onready var castle_music = load("res://Music/Castle.wav")
@onready var transition_music = load("res://Music/Transition.wav")
@onready var enemy_music = load("res://Music/Enemy.wav")
@onready var victory_music = load("res://Music/Victory.wav")

var debug: bool = true

func _ready() -> void:
	tuto_step = 1
	rng.randomize()
	connect_signals()
	
	$Units/Loup.set_script(null)
	$Units/Archer.set_script(null)
	$Units/Paladin.set_script(null)
	$Units/Mage.set_script(null)
	$Units/Soldier.set_script(null)
	$Units/Bard.set_script(null)
	$Units/Bourreau.set_script(null)
	$Units/Charlatan.set_script(null)
	$Units/Colosse.set_script(null)
	$Units/Tavernier.set_script(null)
	$Units/IngeJR.set_script(null)
	$Units/IngeSR.set_script(null)
	

	$UI.lock_player_tuto()
	await get_tree().create_timer(1).timeout
	$UI.update_tuto_text(Vector2(300, 300), "Bienvenue dans Dicey Defense ! \n\n\n[color=5d5d5d]Cliquez pour continuer...", 40)
	
func connect_signals() -> void:
	$King/Button.pressed.connect(on_king_pressed)
	$King/Button.mouse_entered.connect(enable_tooltip.bind(true))
	$King/Button.mouse_exited.connect(disable_tooltip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !$Music.playing:
		$Music.play()
	if waveStarted and enemies_in_wave == 0 and playing:
		print("FIN DE VAGUE")
		waveStarted = false
		Engine.set_time_scale(1.0)
		$Music.set_pitch_scale(1.0)
		$UI/CanvasLayer/Vague/Controls/SpeedUp.button_pressed = false
		if current_wave == 1:
			victory()
			king_anim.play("join_city")
			await king_anim.animation_finished
			king_anim.play("celebrate")
		else:
			music_transition(false)
			king_anim.play("join_city")
			await king_anim.animation_finished
			update_phase()


func _on_ui_roll(unfrozen: Array) -> void:
	
	var unfrozen_id: Array = []
	if tuto_step == 7: hand = [5, 5, 1, 2, 5]
	else: hand = [2, 5, 6, 3, 5]
	"""for i in range(len(unfrozen)):
		unfrozen_id.append((str(unfrozen[i].name).right(1)).to_int() - 1)
	for i in range(5):
		if i in unfrozen_id:
			hand[i] = rng.randi_range(1, 6)"""
	$YamsManager.calcul_hand(hand)
	$UI.update_hand(hand)
	if king_anim != null and not king_anim.is_playing():
		king_anim.play("roll_dice")
	
	$Units/Builder.level = $YamsManager.combinaisons[GameData.unit_data["Builder"]["value"]][2]

func update_phase() -> void:
	if(waveStarted): king_anim.play("leave_city")
	$UI.update_phase(waveStarted, current_wave)
	for unit in $Units.get_children():
		unit.visible = false
	$Units/Builder.visible = true
	$Units/Builder.turn(1)
	$Units/Builder.start_wave()
	
			
	for temp in $Temporary.get_children():
		temp.queue_free()
	for follow in $KingsRoad.get_children():
		follow.queue_free()
	
### Gestion de vagues

func start_next_wave() -> void:
	next_step()
	
func really_start_next_wave() -> void:
	var wave_data: Array = retrieve_wave_data()
	enemies_in_wave = 0
	for group in wave_data:
		enemies_in_wave += group[0]
	waveStarted = true
	update_phase()
	$UI.text_animation.play("wavestart")
	music_transition(true)
	await get_tree().create_timer(2.4).timeout
	$UI.text_animation.play("RESET")
	spawn_enemies(wave_data)
	
func music_transition(start: bool) -> void:
	var tween: Tween = create_tween()
	var baseDB: float = $Music.volume_db
	if start:
		$Music.set_stream(transition_music)
		$Music.play()
		tween.tween_property($Music, "volume_db", -30, 2.5)
		await tween.finished
		$Music.volume_db = baseDB
		$Music.set_stream(enemy_music)
		$Music.play()
	else:
		tween.tween_property($Music, "volume_db", -30, 2.5)
		await tween.finished
		$Music.volume_db = baseDB
		$Music.set_stream(castle_music)
		$Music.play()
	

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
			var new_enemy = load("res://Scenes/Enemies/" + group[1].left(-1) + ".tscn").instantiate()
			new_enemy.death.connect(on_enemy_death)
			$KingsRoad.add_child(new_enemy, true)
			
			if group[1].right(1) == "2":
				new_enemy.get_node("CharacterBody2d/Sprite2d").modulate = Color("db874b")
				new_enemy.baseColor = Color("db874b")
				new_enemy.baseHP = new_enemy.baseHP * 2
				new_enemy.update_stats()
				
			await get_tree().create_timer(group[2]).timeout
		await get_tree().create_timer(group[3]).timeout
		
func on_enemy_death(nexus_dmg: float) -> void:
	
	if nexus_dmg != 0:
		$Camera2d.trigger_shake(3, 0.2, true)
		Sfx.damage_sound()
		nexus_hp -= nexus_dmg
		if nexus_hp <= 0:
			nexus_hp = 0
			game_over()
		$UI.update_health(nexus_hp)
	else:
		pass#$Camera2d.trigger_shake(0.2, 0.1, false)
	enemies_in_wave -= 1

func game_over() -> void:
	Engine.set_time_scale(1.0)
	$Music.set_pitch_scale(0.75)
	$UI.game_over()
	$Decor/Fire.visible = true
	$Decor/FireSound.play()
	playing = false
	for fire in $Decor/Fire.get_children():
		fire.get_node("Sprite2d").frame = rng.randi_range(0, 6)
		fire.get_node("Sprite2d").playing = true
	for enemy in $KingsRoad.get_children(): # DANSE
		enemy.dead = true
		enemy.animation_player.play("dance")
		enemy.health_bar.visible = false
	for unit in $Units.get_children(): # CRI D'HORREUR
		if unit.activated : unit.queue_free()
		

func victory() -> void:
	$UI.victory()
	$Music.set_stream(victory_music)
	$Music.play()
	for temp in $Temporary.get_children():
		temp.queue_free()
	for follow in $KingsRoad.get_children():
		follow.queue_free()
	$Units/Builder.activated = false
	$Units/Builder.animation_player.play("celebrate")
	king_anim.play("celebrate")
	
func load_gamestate() -> void:
	save_system.load_game()
	
	nexus_hp = save_system.game_data["nexus_hp"]
	current_wave = save_system.game_data["current_wave"]
	$YamsManager.grille = save_system.game_data["grille"]
	
	$YamsManager.compute_score()
	
	$UI.update_health(nexus_hp)
	$UI.waveNumber.text = "Prochaine vague : " + str(current_wave + 1) + "/13"
	
	for unit in $Units.get_children():
		var unit_data: Dictionary = save_system.game_data[unit.unitName]
		if unit_data["level"] == 0:
			unit.queue_free()
		elif unit_data["level"] > 0:
			unit.level = unit_data["level"]
			unit.on_activate()
			unit.button.modulate = Color(1, 1, 1)
			unit.button.disabled = true
			unit.activated = true
			unit.rangeSprite.modulate.a = 0
			unit.damage_dealt = unit_data["damage"]
			unit.update_tooltip()
			
			unit.unit_sprite.visible = true
			unit.button.modulate.a = 0
			unit.idle_anim()
			unit.disable_tooltip()
			
func save_gamestate() -> void:
	save_system.game_data["nexus_hp"] = nexus_hp
	save_system.game_data["current_wave"] = current_wave
	save_system.game_data["grille"] = $YamsManager.grille
	for unit in $Units.get_children():
		if unit.activated : 
			save_system.game_data[unit.unitName]["damage"] = unit.damage_dealt
	save_system.save_game()
	

func on_king_pressed() -> void:
	if $UI.coupsRestant > 0:
		$UI.press_roll()
	enable_tooltip(false)

func enable_tooltip(sound: bool) -> void:
	if not $King/Button.is_disabled():
		if sound:
			Sfx.hover_sound()
		$King/CanvasLayer/Tooltip.visible = true
		$King/Hover.visible = true
		var coups: int = $UI.coupsRestant
		if coups == 0:
			$King/CanvasLayer/Tooltip/Description.text = "Souverain qui protège avec intêret son royaume en \
utilisant le pouvoir des reliques sacrées\n
[color=e9994f](Aucun lancer restant)"
		elif coups == 1:
			$King/CanvasLayer/Tooltip/Description.text = "Souverain qui protège avec intêret son royaume en \
utilisant le pouvoir des reliques sacrées\n
[color=e9994f](1 lancer restant)"
		else:
			$King/CanvasLayer/Tooltip/Description.text = "Souverain qui protège avec intêret son royaume en \
utilisant le pouvoir des reliques sacrées\n
[color=e9994f]({0} lancers restant)".format([$UI.coupsRestant])

func disable_tooltip() -> void:
	$King/CanvasLayer/Tooltip.visible = false
	$King/Hover.visible = false
	
func buff_barracks() -> void:
	nexus_hp += 15
	$AudioStreamPlayer.play()
	$UI.update_health(nexus_hp)
	
	var shield_animation: AnimationPlayer = $UI/CanvasLayer/Health/AnimationPlayer
	shield_animation.play("upgrade_shield_no_glow")
	await shield_animation.animation_finished
	shield_animation.play("shield_sparkle")
	
func next_step() -> void:
	if tuto_step == 1:
		$UI.update_tuto_text(Vector2(500, 700), "Dans Dicey Defense, vous incarnez le souverain d'un royaume venant de mettre la main sur des reliques sacrées \n\n[color=5d5d5d]Cliquez pour continuer...", 60)
	if tuto_step == 2:
		$UI.update_tuto_text(Vector2(500, 700), "Ces reliques peuvent être utilisées pour renforcer la force armée de votre royaume \n\n[color=5d5d5d]Cliquez pour continuer...", 50)
	if tuto_step == 3:
		$UI.update_tuto_text(Vector2(700, 700), "En plus des reliques, vous disposez d'un gobelet pour obtenir de puissantes combinaisons \n\n[color=5d5d5d]Cliquez pour continuer...", 50)
	if tuto_step == 4:
		$UI.update_tuto_text(Vector2(500, 700), "Vous pouvez conserver certaines reliques lors de l'utilisation du gobelet en leur cliquant dessus\n\n[color=5d5d5d]Cliquez pour continuer...", 50)
	if tuto_step == 5:
		$UI.update_tuto_text(Vector2(200, 450), "Essayez par exemple de conserver les deux reliques affichant un 5", 30)
		$UI.unlock_player_tuto("Dices")
	if tuto_step == 6:
		$UI.update_tuto_text(Vector2(700, 700), "Super, maintenant essayez d'utiliser le gobelet sacré en cliquant dessus !", 35)
		$UI.unlock_player_tuto("Gobelet")
	if tuto_step == 7:
		$UI.update_tuto_text(Vector2(450, 500), "Woaw, un autre 5 ! Essayons maintenant d'utiliser les reliques pour renforcer notre armée !\n\n[color=5d5d5d]Cliquez pour continuer...", 50)
	if tuto_step == 8:
		$UI.update_tuto_text(Vector2(750, 350), "Vous pouvez recruter une unité en lui cliquant dessus.\n\nUtilisez votre brelan pour recruter un bâtisseur capable d'ériger une barricade aux portes du château !", 75)
		$UI.unlock_player_tuto("Units")
	if tuto_step == 9:
		get_tree().paused = true
		$UI.update_tuto_text(Vector2(900, 550), "Bravo ! Vous possédez désormais un bâtisseur de niveau 5, car vous avez utilisé un brelan de 5\n\n[color=5d5d5d]Cliquez pour continuer...", 60)
	if tuto_step == 10:
		$UI.update_tuto_text(Vector2(900, 550), "Le niveau des unités dépend de votre combinaison de reliques, mais ils ne suivent pas tous les même règles, à vous de les trouver !\n\n[color=5d5d5d]Cliquez pour continuer...", 65)
	if tuto_step == 11:
		$UI.update_tuto_text(Vector2(200, 100), "Il est maintenant l'heure de défendre le roi ! Vous pouvez observer le nombre de points de vie restants avant que les dernières défenses du roi ne tombent\n\n[color=5d5d5d]Cliquez pour continuer...", 80)
	if tuto_step == 12:
		$UI.update_tuto_text(Vector2(-500, -500), "Il est maintenant l'heure de défendre le roi ! Vous pouvez observer le nombre de points de vie restants avant que les dernières défenses du roi ne tombent\n\n[color=5d5d5d]Cliquez pour continuer...", 60)
		really_start_next_wave()
		get_tree().paused = false
	tuto_step += 1
	
