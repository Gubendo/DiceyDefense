extends Control

signal roll(unfrozenDices)
signal choix(coup)
var diceHand: String = "CanvasLayer/Overlay/DiceHand/"
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var dicesList: Array = [get_node(diceHand + "Dice1"), get_node(diceHand + "Dice2"), get_node(diceHand + "Dice3"), get_node(diceHand + "Dice4"), get_node(diceHand + "Dice5")]
@onready var gobelet: TextureButton = $CanvasLayer/Overlay/Gobelet
@onready var pausePlay: TextureButton = $CanvasLayer/Vague/Controls/PausePlay
@onready var speedUp: TextureButton = $CanvasLayer/Vague/Controls/SpeedUp

@onready var optionsButton: Button = $CanvasLayer/Pause/Options
@onready var statsButton: Button = $CanvasLayer/Pause/Stats
@onready var quitButton: Button = $CanvasLayer/Pause/Quitter
@onready var restartButton: Button = $CanvasLayer/Pause/Recommencer

@onready var waveNumber: Label = $CanvasLayer/Vague/number
@onready var remainingEnemies: Label = $CanvasLayer/Vague/remaining
@onready var pauseMenu: Control = $CanvasLayer/Pause
@onready var healthValue: Label = $CanvasLayer/Health/Value

@onready var overlay_animation: AnimationPlayer = $CanvasLayer/OverlayAnimation
@onready var text_animation: AnimationPlayer = $CanvasLayer/TextAnimation
@onready var help_animation: AnimationPlayer = $CanvasLayer/HelpAnimation

var overlay_animations: Dictionary = {true: "hide_overlay", false: "show_overlay"}

var unfrozenDices: Array = []
var frozenDices: Array = []
var unfrozen_dice_pos: Dictionary = {0: Vector2(195, 700), 1: Vector2(300, 670), \
2: Vector2(215, 800), 3: Vector2(350, 760), 4: Vector2(320, 865)}
var frozen_dice_pos: Dictionary = {0: Vector2(720, 900), 1: Vector2(800, 900), \
2: Vector2(880, 900), 3: Vector2(750, 820), 4: Vector2(830, 820)}

@export var dicesSprites: Array[Texture2D]
@export var nbRolls: int = 30

var coupsRestant: int

var locked: bool = false
var helpOpen: bool = false

var save_system = SaveSystem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	rng.randomize()
	coupsRestant = nbRolls + 1
	for dice in dicesList:
		unfrozenDices.append(dice)
	connect_signals()
	update_dice_pos()
	nouveau_coup()
	overlay_animation.play("fade_overlay")
	
	$CanvasLayer/Settings/Popup.settings_open.connect(lock_input)
	$CanvasLayer/Settings/Popup.settings_close.connect(unlock_input)
	
	$CanvasLayer/Statistics/Container.stats_open.connect(lock_input)
	$CanvasLayer/Statistics/Container.stats_close.connect(unlock_input)
	unlock_input()
	

func connect_signals() -> void:
	gobelet.mouse_entered.connect(enable_tooltip_gobelet)
	gobelet.mouse_exited.connect(disable_tooltip_gobelet)
	gobelet.pressed.connect(press_roll)
	
	pausePlay.pressed.connect(on_PausePlay_pressed)
	speedUp.pressed.connect(on_SpeedUp_pressed)
	
	quitButton.pressed.connect(quit)
	optionsButton.pressed.connect(options)
	statsButton.pressed.connect(stats)
	restartButton.pressed.connect(restart)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap") and not locked and not event.is_echo():
		$CanvasLayer/Vague/Controls/PausePlay.button_pressed = !$CanvasLayer/Vague/Controls/PausePlay.button_pressed
		on_PausePlay_pressed()
	elif Input.is_action_just_pressed("echap") and helpOpen and not event.is_echo():
		trigger_help()
	if Input.is_action_just_pressed("help") and not helpOpen and not locked and not event.is_echo():
		trigger_help()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clic_gauche"):
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		for node in dicesList:
			if node.get_global_rect().has_point(mousePos):
				node.highlight(false)
				if node in frozenDices:
					frozenDices.erase(node)
					unfrozenDices.append(node)
				else:
					frozenDices.append(node)
					unfrozenDices.erase(node)
				update_dice_pos()
				break
				
	if Input.is_action_just_pressed("clic_droit"):
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		for node in dicesList:
			if node.get_global_rect().has_point(mousePos):
				var dice_id: int = str(node.name).right(1).to_int() - 1
				var hand = $/root/Main.hand
				if hand[dice_id] == 6: hand[dice_id] = 1
				else: hand[dice_id] = hand[dice_id] + 1
				$/root/Main/YamsManager.calcul_hand(hand)
				update_hand(hand)
				for unit in $/root/Main/Units.get_children():
					if !unit.activated : 
						unit.level = $/root/Main/YamsManager.combinaisons[GameData.unit_data[unit.name]["value"]][2]
				break
	
		
	var enemies: float = $/root/Main.enemies_in_wave
	if enemies == 0: remainingEnemies.text = "Ennemis vaincus !"
	elif enemies == 1: remainingEnemies.text = "1 ennemi restant"
	else: remainingEnemies.text = str(enemies) + " ennemis restant"
				

func update_dice_pos() -> void:
	var frozen_id: int = 0
	for node in frozenDices:
		node.position = frozen_dice_pos[frozen_id]
		frozen_id += 1
	for node in unfrozenDices:
		var unfrozen_id: int = str(node.name).right(1).to_int() - 1
		node.position = unfrozen_dice_pos[unfrozen_id]

func nouveau_coup() -> void:
	coupsRestant = nbRolls + 1
	for node in frozenDices:
		unfrozenDices.append(node)
	frozenDices.clear()
	press_roll()
	
func press_roll() -> void:
	var rolled_dices: Array = []
	for node in unfrozenDices:
		var unfrozen_id: int = str(node.name).right(1).to_int() - 1
		unfrozen_dice_pos[unfrozen_id] = Vector2(-100, -100)
	update_dice_pos()
	#await get_tree().create_timer(0.5).timeout
	emit_signal("roll", unfrozenDices)

	for node in unfrozenDices:
		var alone: bool = false
		var position: Vector2
		var unfrozen_id: int = str(node.name).right(1).to_int() - 1
		while not alone:
			position = get_random_pos_in_circle(125, 275, 770)
			for node2 in unfrozenDices:
				var unfrozen_id2: int = str(node2.name).right(1).to_int() - 1
				if abs(position.distance_to(unfrozen_dice_pos[unfrozen_id2])) > 90:
					alone = true
				else:
					alone = false
					break
		unfrozen_dice_pos[unfrozen_id] = position
	
	update_dice_pos()
	

func update_hand(hand: Array) -> void:
	for i in range(5):
		dicesList[i].texture = dicesSprites[hand[i] - 1]
	$CanvasLayer/ValeurMain.text = "Main réelle : " + str(hand)
	coupsRestant -= 1
	if coupsRestant == 0:
		gobelet.visible = false
	elif coupsRestant == 1:
		gobelet.get_node("Tooltip/nbLancers").text = str(coupsRestant) + " lancer restant"
	else:
		gobelet.get_node("Tooltip/nbLancers").text = str(coupsRestant) + " lancers restant"
	
func update_phase(waveStarted: bool, currentWave: int) -> void:
	overlay_animation.play(overlay_animations[waveStarted])
	gobelet.get_node("Tooltip").visible = false
	#$CanvasLayer/Vague/Controls.visible = waveStarted
	
	if !waveStarted: nouveau_coup()
	
	if waveStarted:
		waveNumber.text = "Vague " + str(currentWave) + "/13"
		remainingEnemies.visible = true
	else:
		waveNumber.text = "Prochaine vague : " + str(currentWave + 1) + "/13"
		remainingEnemies.visible = false
		
	
func on_PausePlay_pressed() -> void:
	if get_tree().is_paused():
		get_tree().paused = false
		for node in pauseMenu.get_children():
			node.visible = false
		$CanvasLayer/PauseOverlay.visible = false
	else:
		get_tree().paused = true
		for node in pauseMenu.get_children():
			node.visible = true
		#pauseMenu.get_node("Options").visible = false
		$CanvasLayer/PauseOverlay.visible = true
		
func on_SpeedUp_pressed() -> void:
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
		
func enable_tooltip_gobelet() -> void:
	gobelet.get_node("Tooltip").visible = true
	
func disable_tooltip_gobelet() -> void:
	gobelet.get_node("Tooltip").visible = false
	
func get_random_pos_in_circle (radius : float, centerX: float, centerY: float) -> Vector2:
	var r: float = sqrt(rng.randf_range(0, 1)) * radius
	var theta: float = rng.randf_range(0, 1) * 2 * PI
	
	return Vector2(centerX + r*cos(theta), centerY + r*sin(theta))

func highlight_dices(value: String) -> void:
	var dices: Array = $/root/Main/YamsManager.combinaisons[value][1]
	for i in range(5):
		if i not in dices:
			dicesList[i].modulate = Color(0.3, 0.3, 0.3)
		else:
			dicesList[i].highlight(true)
	
func unhighlight_dices() -> void:
	for dice in dicesList:
		dice.modulate = Color(1, 1, 1)
		dice.highlight(false)

func update_health(health: float) -> void:
	healthValue.text = str(health)
	
func update_barracks(barracks_score: int, barracks_max: int) -> void:
	$CanvasLayer/Health/Progress.value = barracks_score
	$CanvasLayer/Health/Progress.max_value = barracks_max
	$CanvasLayer/Health/ProgressValue.text = str(min(barracks_score, barracks_max)) + "/" + str(barracks_max)
	
func quit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")
	
func options() -> void:
	$CanvasLayer/Settings/Popup.open_window()
	
func stats() -> void:
	$CanvasLayer/Statistics/Container.open_window()

func restart() -> void:
	save_system.reset_save()
	get_tree().reload_current_scene()
	get_tree().paused = false
	
func game_over() -> void:
	#get_tree().paused = true
	for node in $CanvasLayer/Vague.get_children():
		node.visible = false
		
	for node in pauseMenu.get_children():
			node.visible = true
	#pauseMenu.get_node("Options").visible = false
	
	$CanvasLayer/PauseOverlay.visible = true
	$CanvasLayer/GameOver.visible = true
	
func lock_input() -> void:
	$CanvasLayer.move_child($CanvasLayer/PauseOverlay, 11)
	locked = true
	
func unlock_input() -> void:
	$CanvasLayer.move_child($CanvasLayer/PauseOverlay, 4)
	await get_tree().create_timer(0.01).timeout
	locked = false
	
func trigger_help() -> void:
	if helpOpen: 
		help_animation.play("hide_help")
		helpOpen = false
		unlock_input()
	else:
		if !get_tree().is_paused():
			$CanvasLayer/Vague/Controls/PausePlay.button_pressed = !$CanvasLayer/Vague/Controls/PausePlay.button_pressed
			on_PausePlay_pressed()
			
		help_animation.play("show_help")
		helpOpen = true
		lock_input()

