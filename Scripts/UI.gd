extends Control

signal roll(unfrozenDices)
signal choix(coup)
@onready var dicesList = [get_node("CanvasLayer/DiceHand/Dice1"), get_node("CanvasLayer/DiceHand/Dice2"), get_node("CanvasLayer/DiceHand/Dice3"), get_node("CanvasLayer/DiceHand/Dice4"), get_node("CanvasLayer/DiceHand/Dice5")]
var unfrozenDices = []
var frozenDices = []
@export var dicesSprites: Array[Texture2D]

@export var nbCoups = 2
var coupsRestant
# Called when the node enters the scene tree for the first time.
func _ready():
	coupsRestant = nbCoups + 1
	for dice in dicesList:
		unfrozenDices.append(dice)
	update_dice_pos()


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
		node.position.y = 950
		frozen_id += 1
	for node in unfrozenDices:
		node.position.x = 330 + 100*unfrozen_id
		node.position.y = 950
		unfrozen_id += 1

func nouveau_coup():
	coupsRestant = nbCoups + 1
	get_node("CanvasLayer/RollButton").visible = true
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
	get_node("CanvasLayer/nbCoups").text = "Coups restants : " + str(coupsRestant)
	if coupsRestant == 0:
		get_node("CanvasLayer/RollButton").visible = false
	
		

func update_combi(combinaisons):
	get_node("CanvasLayer/Coups/Total1").text = "Total des 1\n" + str(combinaisons["total1"]) + " points"
	get_node("CanvasLayer/Coups/Total2").text = "Total des 2\n" + str(combinaisons["total2"]) + " points"
	get_node("CanvasLayer/Coups/Total3").text = "Total des 3\n" + str(combinaisons["total3"]) + " points"
	get_node("CanvasLayer/Coups/Total4").text = "Total des 4\n" + str(combinaisons["total4"]) + " points"
	get_node("CanvasLayer/Coups/Total5").text = "Total des 5\n" + str(combinaisons["total5"]) + " points"
	get_node("CanvasLayer/Coups/Total6").text = "Total des 6\n" + str(combinaisons["total6"]) + " points"
	get_node("CanvasLayer/Coups/Brelan").text = "Brelan\n" + str(combinaisons["brelan"]) + " points"
	get_node("CanvasLayer/Coups/Carre").text = "Carré\n" + str(combinaisons["carre"]) + " points"
	get_node("CanvasLayer/Coups/Full").text = "Full\n" + str(combinaisons["full"]) + " points"
	get_node("CanvasLayer/Coups/PSuite").text = "Petite suite\n" + str(combinaisons["p_suite"]) + " points"
	get_node("CanvasLayer/Coups/GSuite").text = "Grande suite\n" + str(combinaisons["g_suite"]) + " points"
	get_node("CanvasLayer/Coups/Chance").text = "Chance\n" + str(combinaisons["chance"]) + " points"
	get_node("CanvasLayer/Coups/Yams").text = "Yams\n" + str(combinaisons["yams"]) + " points"
	
func update_grille(grille):
	get_node("CanvasLayer/Grille").text = "Grille \n\nTotal des 1 : {0}\nTotal des 2 : {1}\nTotal des 3 : {2}
	Total des 4 : {3}\nTotal des 5 : {4}\nTotal des 6 : {5}\nBrelan : {6}\nCarré : {7}\nFull : {8}
	Petite suite : {9}\nGrande suite : {10}\nChance : {11}\nYam's : {12}".format([
	grille["total1"], grille["total2"], grille["total3"], grille["total4"], grille["total5"],
	grille["total6"], grille["brelan"], grille["carre"], grille["full"], grille["p_suite"],
	grille["g_suite"], grille["chance"], grille["yams"]])
	nouveau_coup()

func _on_total_1_pressed():
	emit_signal("choix", "total1")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Total1").visible = false

func _on_total_2_pressed():
	emit_signal("choix", "total2")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Total2").visible = false

func _on_total_3_pressed():
	emit_signal("choix", "total3")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Total3").visible = false

func _on_total_4_pressed():
	emit_signal("choix", "total4")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Total4").visible = false

func _on_total_5_pressed():
	emit_signal("choix", "total5")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Total5").visible = false

func _on_total_6_pressed():
	emit_signal("choix", "total6")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Total6").visible = false

func _on_brelan_pressed():
	emit_signal("choix", "brelan")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Brelan").visible = false

func _on_carre_pressed():
	emit_signal("choix", "carre")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Carre").visible = false

func _on_full_pressed():
	emit_signal("choix", "full")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Full").visible = false

func _on_p_suite_pressed():
	emit_signal("choix", "p_suite")
	nouveau_coup()
	get_node("CanvasLayer/Coups/PSuite").visible = false

func _on_g_suite_pressed():
	emit_signal("choix", "g_suite")
	nouveau_coup()
	get_node("CanvasLayer/Coups/GSuite").visible = false

func _on_chance_pressed():
	emit_signal("choix", "chance")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Chance").visible = false

func _on_yams_pressed():
	emit_signal("choix", "yams")
	nouveau_coup()
	get_node("CanvasLayer/Coups/Yams").visible = false

	
