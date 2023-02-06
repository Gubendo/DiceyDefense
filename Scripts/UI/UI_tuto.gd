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
@export var nbRolls: int = 1

var coupsRestant: int

var locked: bool = false
var helpOpen: bool = false

var firstDice: bool = false
var secondDice: bool = false

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

	
	$CanvasLayer/Overlay/DiceHand/Dice1.disconnect_signal()
	$CanvasLayer/Overlay/DiceHand/Dice3.disconnect_signal()
	$CanvasLayer/Overlay/DiceHand/Dice4.disconnect_signal()
	

func connect_signals() -> void:
	gobelet.mouse_entered.connect(enable_tooltip_gobelet)
	gobelet.mouse_exited.connect(disable_tooltip_gobelet)
	gobelet.pressed.connect(press_roll)

	speedUp.pressed.connect(on_SpeedUp_pressed)
	
	quitButton.pressed.connect(quit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("clic_gauche"):
		if $/root/Main.tuto_step in [1, 2, 3, 4, 5, 8, 10, 11, 12]:
			$/root/Main.next_step()
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		if $/root/Main.tuto_step == 6:
			var dice1 = dicesList[1]
			if dice1.get_global_rect().has_point(mousePos):
				dice1.highlight(false)
				Sfx.shuffle_dice()
				frozenDices.append(dice1)
				unfrozenDices.erase(dice1)
				update_dice_pos()
				firstDice = true
				if secondDice: $/root/Main.next_step()
			
			var dice2 = dicesList[4]
			if dice2.get_global_rect().has_point(mousePos):
				dice2.highlight(false)
				Sfx.shuffle_dice()
				frozenDices.append(dice2)
				unfrozenDices.erase(dice2)
				update_dice_pos()
				secondDice = true
				if firstDice: $/root/Main.next_step()
				
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
	Sfx.roll_dice()
	for node in unfrozenDices:
		var unfrozen_id: int = str(node.name).right(1).to_int() - 1
		unfrozen_dice_pos[unfrozen_id] = Vector2(-100, -100)
	update_dice_pos()
	emit_signal("roll", unfrozenDices)
	if $/root/Main.tuto_step == 7:
		$/root/Main.next_step()
		

	for node in unfrozenDices:
		var alone: bool = false
		var dice_position: Vector2
		var unfrozen_id: int = str(node.name).right(1).to_int() - 1
		while not alone:
			dice_position = get_random_pos_in_circle(125, 275, 770)
			for node2 in unfrozenDices:
				var unfrozen_id2: int = str(node2.name).right(1).to_int() - 1
				if abs(dice_position.distance_to(unfrozen_dice_pos[unfrozen_id2])) > 90:
					alone = true
				else:
					alone = false
					break
		unfrozen_dice_pos[unfrozen_id] = dice_position
	
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
	
	if !waveStarted: nouveau_coup()
	
	if waveStarted:
		waveNumber.text = "Vague " + str(currentWave) + "/13"
		remainingEnemies.visible = true
	else:
		waveNumber.text = "Prochaine vague : " + str(currentWave + 1) + "/13"
		remainingEnemies.visible = false
		
	
func on_SpeedUp_pressed() -> void:
	Sfx.click_button()
	if Engine.get_time_scale() == 2.0:
		$/root/Main/Music.set_pitch_scale(1.0)
		Engine.set_time_scale(1.0)
	else:
		$/root/Main/Music.set_pitch_scale(1.5)
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


func quit() -> void:
	Sfx.click_button()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")
	
	
func victory() -> void:
	for node in $CanvasLayer/Vague.get_children():
		node.visible = false
		
	for node in pauseMenu.get_children():
			node.visible = true
	
	$CanvasLayer/PauseOverlay.visible = true
	$CanvasLayer/Victory.visible = true
	$CanvasLayer/Victory/Fireworks/Timer.start()

		
func update_tuto_text(text_pos: Vector2, text: String, size_px: int) -> void:
	var path: String = "res://Sprites/UI/tooltips/tooltip-" + str(size_px) + "px.png"
	var tooltip_text: Texture2D = load(path)
	$CanvasLayer/Tuto/Tooltip/bg.texture = tooltip_text
	$CanvasLayer/Tuto/Tooltip/bg.size.y = 0
	$CanvasLayer/Tuto/Tooltip.position = text_pos
	$CanvasLayer/Tuto/Tooltip/Text.text = text
	
func lock_player_tuto() -> void:
	$CanvasLayer/TutoOverlay.visible = true

func update_barracks(score: int, max: int) -> void:
	pass
	
func unlock_player_tuto(element: String) -> void:
	if element == "Dices":
		$CanvasLayer.move_child($CanvasLayer/TutoOverlay, 4)
		$CanvasLayer/Overlay/Gobelet.z_index = -10
	if element == "Gobelet":
		$CanvasLayer/Overlay/Gobelet.z_index = 10
		$CanvasLayer/Overlay/DiceHand/Dice2.disconnect_signal()
		$CanvasLayer/Overlay/DiceHand/Dice5.disconnect_signal()
	if element == "Units":
		$CanvasLayer/TutoOverlay.visible = false

