extends Control

signal roll(unfrozenDices)
signal choix(coup)
var diceHand: String = "CanvasLayer/Overlay/DiceHand/"
@onready var dicesList: Array = [get_node(diceHand + "Dice1"), get_node(diceHand + "Dice2"), get_node(diceHand + "Dice3"), get_node(diceHand + "Dice4"), get_node(diceHand + "Dice5")]
@onready var gobelet: TextureButton = get_node("CanvasLayer/Overlay/Gobelet")
@onready var pausePlay: TextureButton = get_node("CanvasLayer/Vague/Controls/PausePlay")
@onready var speedUp: TextureButton = get_node("CanvasLayer/Vague/Controls/SpeedUp")

var unfrozenDices: Array = []
var frozenDices: Array = []
var unfrozen_dice_pos: Dictionary = {0: Vector2(195, 700), 1: Vector2(300, 670), \
2: Vector2(215, 800), 3: Vector2(350, 760), 4: Vector2(320, 865)}
var frozen_dice_pos: Dictionary = {0: Vector2(1100, 100), 1: Vector2(1200, 200), \
2: Vector2(1300, 300), 3: Vector2(1400, 400), 4: Vector2(1500, 500)}

@export var dicesSprites: Array[Texture2D]
@export var nbRolls: int = 2

var coupsRestant: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coupsRestant = nbRolls + 1
	for dice in dicesList:
		unfrozenDices.append(dice)
	connect_signals()
	update_dice_pos()
	nouveau_coup()
	

func connect_signals() -> void:
	gobelet.mouse_entered.connect(enable_tooltip_gobelet)
	gobelet.mouse_exited.connect(disable_tooltip_gobelet)
	gobelet.pressed.connect(press_roll)
	pausePlay.pressed.connect(on_PausePlay_pressed)
	speedUp.pressed.connect(on_SpeedUp_pressed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clic_gauche"):
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		for node in dicesList:
			if node.get_global_rect().has_point(mousePos):
				if node in frozenDices:
					node.modulate = Color(1, 1, 1)
					frozenDices.erase(node)
					unfrozenDices.append(node)
				else:
					node.modulate = Color(0.5, 0.5, 0.5)
					frozenDices.append(node)
					unfrozenDices.erase(node)
				update_dice_pos()
				break
				

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
		node.modulate = Color(1, 1, 1)
	frozenDices.clear()
	update_dice_pos()
	emit_signal("roll", unfrozenDices)
	
func press_roll() -> void:
	print(len(unfrozenDices))
	emit_signal("roll", unfrozenDices)
	

func update_hand(hand: Array) -> void:
	for i in range(5):
		dicesList[i].texture = dicesSprites[hand[i] - 1]
	get_node("CanvasLayer/ValeurMain").text = "Main réelle : " + str(hand)
	coupsRestant -= 1
	if coupsRestant == 0:
		gobelet.visible = false
	elif coupsRestant == 1:
		gobelet.get_node("Tooltip/nbLancers").text = str(coupsRestant) + " lancer restant"
	else:
		gobelet.get_node("Tooltip/nbLancers").text = str(coupsRestant) + " lancers restant"
	
func update_phase(waveStarted: bool, currentWave: int) -> void:
	get_node("CanvasLayer/Overlay").visible = !waveStarted
	gobelet.visible = !waveStarted
	gobelet.get_node("Tooltip").visible = false
	get_node("CanvasLayer/Vague/Controls").visible = waveStarted
	
	if !waveStarted: nouveau_coup()
	
	if waveStarted:
		get_node("CanvasLayer/Vague/number").text = "Vague " + str(currentWave) + "/13"
	else:
		get_node("CanvasLayer/Vague/number").text = "Prochaine vague : " + str(currentWave + 1) + "/13"
		

func update_grille(grille: Dictionary) -> void:
	get_node("CanvasLayer/Grille").text = "Grille (DEV)\n\nTotal des 1 : {0}\nTotal des 2 : {1}\nTotal des 3 : {2}
	Total des 4 : {3}\nTotal des 5 : {4}\nTotal des 6 : {5}\nBrelan : {6}\nCarré : {7}\nFull : {8}
	Petite suite : {9}\nGrande suite : {10}\nChance : {11}\nYam's : {12}".format([
	grille["total1"], grille["total2"], grille["total3"], grille["total4"], grille["total5"],
	grille["total6"], grille["brelan"], grille["carre"], grille["full"], grille["p_suite"],
	grille["g_suite"], grille["chance"], grille["yams"]])
	
func on_PausePlay_pressed() -> void:
	if get_tree().is_paused():
		get_tree().paused = false
	else:
		get_tree().paused = true
		
func on_SpeedUp_pressed() -> void:
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
		
func enable_tooltip_gobelet() -> void:
	gobelet.get_node("Tooltip").visible = true
	
func disable_tooltip_gobelet() -> void:
	gobelet.get_node("Tooltip").visible = false

