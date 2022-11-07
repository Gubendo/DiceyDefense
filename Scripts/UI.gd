extends Control

signal roll(unfrozenDices)
signal choix(coup)
@onready var dicesList = [get_node("CanvasLayer/DiceHand/Dice1"), get_node("CanvasLayer/DiceHand/Dice2"), get_node("CanvasLayer/DiceHand/Dice3"), get_node("CanvasLayer/DiceHand/Dice4"), get_node("CanvasLayer/DiceHand/Dice5")]
var unfrozenDices = []
var frozenDices = []
@export var dicesSprites: Array[Texture2D]

@export var nbRolls = 2
var coupsRestant
# Called when the node enters the scene tree for the first time.
func _ready():
	coupsRestant = nbRolls + 1
	for dice in dicesList:
		unfrozenDices.append(dice)
	update_dice_pos()
	nouveau_coup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("clic_gauche"):
		var mousePos = get_viewport().get_mouse_position()
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
				

func update_dice_pos():
	var unfrozen_id = 0
	var frozen_id = 0
	for node in frozenDices:
		node.position.x = 1330 + 100*frozen_id
		node.position.y = 900
		frozen_id += 1
	for node in unfrozenDices:
		node.position.x = 330 + 100*unfrozen_id
		node.position.y = 900
		unfrozen_id += 1

func nouveau_coup():
	coupsRestant = nbRolls + 1
	for node in frozenDices:
		unfrozenDices.append(node)
		node.modulate = Color(1, 1, 1)
	frozenDices.clear()
	update_dice_pos()
	emit_signal("roll", unfrozenDices)
	
func _on_roll_pressed():
	emit_signal("roll", unfrozenDices)
	

func update_hand(hand):
	for i in range(5):
		dicesList[i].texture = dicesSprites[hand[i] - 1]
	get_node("CanvasLayer/ValeurMain").text = "Main réelle : " + str(hand)
	coupsRestant -= 1
	if coupsRestant == 0:
		get_node("CanvasLayer/nbLancer").visible = false
		get_node("CanvasLayer/RollButton").visible = false
	else:
		get_node("CanvasLayer/nbLancer").text = "Lancers restants : " + str(coupsRestant)
	
func update_phase(waveStarted, currentWave):
	get_node("CanvasLayer/DiceHand").visible = !waveStarted
	get_node("CanvasLayer/RollButton").visible = !waveStarted
	get_node("CanvasLayer/nbLancer").visible = !waveStarted
	get_node("CanvasLayer/Relancer").visible = !waveStarted
	get_node("CanvasLayer/Garder").visible = !waveStarted
	
	if !waveStarted: nouveau_coup()
	
	if waveStarted:
		get_node("CanvasLayer/Vague").text = "Vague " + str(currentWave) + "/13"
	else:
		get_node("CanvasLayer/Vague").text = "Prochaine vague : " + str(currentWave + 1) + "/13"
		

func update_grille(grille):
	get_node("CanvasLayer/Grille").text = "Grille (DEV)\n\nTotal des 1 : {0}\nTotal des 2 : {1}\nTotal des 3 : {2}
	Total des 4 : {3}\nTotal des 5 : {4}\nTotal des 6 : {5}\nBrelan : {6}\nCarré : {7}\nFull : {8}
	Petite suite : {9}\nGrande suite : {10}\nChance : {11}\nYam's : {12}".format([
	grille["total1"], grille["total2"], grille["total3"], grille["total4"], grille["total5"],
	grille["total6"], grille["brelan"], grille["carre"], grille["full"], grille["p_suite"],
	grille["g_suite"], grille["chance"], grille["yams"]])

