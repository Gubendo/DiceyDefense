extends Node

var grille = {
	"total1": -1,
	"total2": -1,
	"total3": -1,
	"total4": -1,
	"total5": -1,
	"total6": -1,
	"brelan": -1,
	"carre": -1,
	"full": -1,
	"p_suite": -1,
	"g_suite": -1,
	"chance": -1,
	"yams": -1
}

signal update_combi(combinaisons)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func calcul_total_x(hand: Array, x:int):
	var total = 0
	for dice in hand:
		if dice == x : total += x
		
	return total

func calcul_brelan(hand: Array):
	var brelan = 0
	for i in range(1,7):
		if hand.count(i) >= 3: return hand_sum(hand)
	return 0
	
func calcul_carre(hand: Array):
	var carre = 0
	for i in range(1,7):
		if hand.count(i) >= 4: return hand_sum(hand)
	return 0
	
func calcul_full(hand: Array):
	var full = 0
	var faces = range(1, 7)
	for i in faces:
		if hand.count(i) >= 3:
			faces.erase(i)
			for j in faces:
				if hand.count(j) >= 2: return 25
	return 0
	
func calcul_p_suite(hand: Array):
	if 1 in hand and 2 in hand and 3 in hand and 4 in hand: return 30
	elif 2 in hand and 3 in hand and 4 in hand and 5 in hand: return 30
	elif 3 in hand and 4 in hand and 5 in hand and 6 in hand: return 30
	else: return 0
	
func calcul_g_suite(hand: Array):
	if 1 in hand and 2 in hand and 3 in hand and 4 in hand and 5 in hand: return 40
	elif 2 in hand and 3 in hand and 4 in hand and 5 in hand and 6 in hand: return 40
	else: return 0
	
func calcul_chance(hand: Array):
	return hand_sum(hand)
	
func calcul_yams(hand: Array):
	var yams = 0
	for i in range(1,7):
		if hand.count(i) == 5: return 50
	return 0

func hand_sum(hand: Array):
	var total = 0
	for dice in hand:
		total += dice
	return total


func _on_main_update_hand(hand):
	var combinaisons = [calcul_total_x(hand, 1),calcul_total_x(hand, 2), calcul_total_x(hand, 3), 
	calcul_total_x(hand, 4), calcul_total_x(hand, 5), calcul_total_x(hand, 6),calcul_brelan(hand),
	calcul_carre(hand), calcul_full(hand), calcul_p_suite(hand), calcul_g_suite(hand), 
	calcul_chance(hand), calcul_yams(hand)]
	emit_signal("update_combi", combinaisons)
