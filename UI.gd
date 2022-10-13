extends Control

signal roll(unfrozenDices)
@onready var dicesList = [get_node("CanvasLayer/DiceHand/Dice1"), get_node("CanvasLayer/DiceHand/Dice2"), get_node("CanvasLayer/DiceHand/Dice3"), get_node("CanvasLayer/DiceHand/Dice4"), get_node("CanvasLayer/DiceHand/Dice5")]
var unfrozenDices = []
var frozenDices = []
@export var dicesSprites: Array[Texture2D]
# Called when the node enters the scene tree for the first time.
func _ready():
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
		frozen_id += 1
	for node in unfrozenDices:
		node.position.x = 330 + 100*unfrozen_id
		unfrozen_id += 1

func _on_roll_pressed():
	emit_signal("roll", unfrozenDices)


func _on_main_update_hand(hand):
	for i in range(5):
		dicesList[i].texture = dicesSprites[hand[i] - 1]
	get_node("CanvasLayer/ValeurMain").text = "Main réelle : " + str(hand)
		


func _on_yams_manager_update_combi(combinaisons):
	get_node("CanvasLayer/Combinaisons").text = "Total des 1 : {0}\nTotal des 2 : {1}\nTotal des 3 : {2}
	Total des 4 : {3}\nTotal des 5 : {4}\nTotal des 6 : {5}\nBrelan : {6}\nCarré : {7}\nFull : {8}
	Petite suite : {9}\nGrande suite : {10}\nChance : {11}\nYam's : {12}".format([
	str(combinaisons[0]), str(combinaisons[1]), str(combinaisons[2]), str(combinaisons[3]), str(combinaisons[4]),
	str(combinaisons[5]), str(combinaisons[6]), str(combinaisons[7]), str(combinaisons[8]), str(combinaisons[9]),
	str(combinaisons[10]), str(combinaisons[11]), str(combinaisons[12])])
