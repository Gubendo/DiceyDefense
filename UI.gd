extends Control

signal roll(frozenDices)
@onready var dicesList = [get_node("CanvasLayer/DiceHand/Dice1"), get_node("CanvasLayer/DiceHand/Dice2"), get_node("CanvasLayer/DiceHand/Dice3"), get_node("CanvasLayer/DiceHand/Dice4"), get_node("CanvasLayer/DiceHand/Dice5")]
var frozenDices = []
@export var dicesSprites: Array[Texture2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("clic_gauche"):
		var mousePos = get_viewport().get_mouse_position()
		for node in dicesList:
			if node.get_global_rect().has_point(mousePos):
				if node in frozenDices:
					node.modulate = Color(1, 1, 1)
					frozenDices.erase(node)
				else:
					node.modulate = Color(0.5, 0.5, 0.5)
					frozenDices.append(node)


func _on_roll_pressed():
	emit_signal("roll", frozenDices)


func _on_main_update_hand(hand):
	for i in range(5):
		dicesList[i].texture = dicesSprites[hand[i] - 1]
