extends Node

var grille: Dictionary = {
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


var combinaisons: Dictionary = {
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

var nodeUI: Control

var global_score: int = 0
var barracks_score: int = 0
var barracks_buff: bool = false
var barracks_max: int = 62

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nodeUI = $/root/Main/UI
	nodeUI.update_barracks(barracks_score, barracks_max)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func calcul_total_x(hand: Array, x: int) -> Array:
	var total: int = 0
	var dices: Array = []
	for i in range(5):
		if hand[i] == x : 
			total += x
			dices.append(i)
		
	return [total, dices, total/x]

func calcul_brelan(hand: Array) -> Array:
	var dices: Array = []
	for i in range(1,7):
		if hand.count(i) >= 3: 
			for j in range(5):
				if hand[j] == i:
					dices.append(j)
			return [hand_sum(hand), dices.slice(0, 3), i]
	return [0, dices, 0]
	
func calcul_carre(hand: Array) -> Array:
	var dices: Array = []
	for i in range(1,7):
		if hand.count(i) >= 4: 
			for j in range(5):
				if hand[j] == i:
					dices.append(j)
			return [hand_sum(hand), dices.slice(0, 4), i]
	return [0, dices, 0]
	
func calcul_full(hand: Array) -> Array:
	var dices: Array = []
	var faces: Array = range(1, 7)
	for i in faces:
		if hand.count(i) >= 3:
			faces.erase(i)
			for j in faces:
				if hand.count(j) >= 2: 
					for k in range(5):
						if hand[k] == i or hand[k] == j:
							dices.append(k)
					
					var level: int
					if hand_sum(hand) <= 14: level = 1
					elif hand_sum(hand) <= 21: level = 2
					else: level = 3
					if hand_sum(hand) == 19: level = 4
					
					return [25, dices, level]
	return [0, dices, 0]
	
func calcul_p_suite(hand: Array) -> Array:
	var dices: Array = []
	if 3 in hand and 4 in hand and 5 in hand and 6 in hand: return [30, [hand.find(3), hand.find(4), hand.find(5), hand.find(6)], 3]
	elif 2 in hand and 3 in hand and 4 in hand and 5 in hand: return [30, [hand.find(2), hand.find(3), hand.find(4), hand.find(5)], 2]
	elif 1 in hand and 2 in hand and 3 in hand and 4 in hand: return [30, [hand.find(1), hand.find(2), hand.find(3), hand.find(4)], 1]
	else: return [0, dices, 0]
	
func calcul_g_suite(hand: Array) -> Array:
	var dices: Array = []
	if 2 in hand and 3 in hand and 4 in hand and 5 in hand and 6 in hand: return [40, [0, 1, 2, 3, 4], 2]
	elif 1 in hand and 2 in hand and 3 in hand and 4 in hand and 5 in hand: return [40, [0, 1, 2, 3, 4], 1]
	else: return [0, dices, 0]
	
func calcul_chance(hand: Array) -> Array:
	var level: int
	if hand_sum(hand) <= 13: level = 1
	elif hand_sum(hand) <= 22: level = 2
	else: level = 3
	if hand_sum(hand) == 24: level = 4
	return [hand_sum(hand), [0, 1, 2, 3, 4], level]
	
func calcul_yams(hand: Array) -> Array:
	var dices: Array = []
	for i in range(1,7):
		if hand.count(i) == 5: return [50, [0, 1, 2, 3, 4], (i+1)/2]
	return [0, dices, 0]

func hand_sum(hand: Array) -> int:
	var total: int = 0
	for dice in hand:
		total += dice
	return total


func calcul_hand(hand) -> void:
	combinaisons['total1'] = calcul_total_x(hand, 1)
	combinaisons['total2'] = calcul_total_x(hand, 2)
	combinaisons['total3'] = calcul_total_x(hand, 3)
	combinaisons['total4'] = calcul_total_x(hand, 4)
	combinaisons['total5'] = calcul_total_x(hand, 5)
	combinaisons['total6'] = calcul_total_x(hand, 6)
	combinaisons['brelan'] = calcul_brelan(hand)
	combinaisons['carre'] = calcul_carre(hand)
	combinaisons['full'] = calcul_full(hand)
	combinaisons['p_suite'] = calcul_p_suite(hand)
	combinaisons['g_suite'] = calcul_g_suite(hand)
	combinaisons['chance'] = calcul_chance(hand)
	combinaisons['yams'] = calcul_yams(hand)

func compute_score() -> void:
	global_score = $/root/Main.nexus_hp
	for score in grille: 
		global_score = global_score + max(0, grille[score])
		
	barracks_score = max(0, grille["total1"]) + max(0, grille["total2"]) + \
	max(0, grille["total3"]) + max(0, grille["total4"]) + \
	max(0, grille["total5"]) + max(0, grille["total6"])
	if barracks_score >= barracks_max and not barracks_buff:
		barracks_buff = true
		$/root/Main.buff_barracks()
	nodeUI.update_barracks(barracks_score, barracks_max)
	
func on_unit_choice(coup) -> void:
	grille[coup] = combinaisons[coup][0]
	compute_score()
	$/root/Main.start_next_wave()
