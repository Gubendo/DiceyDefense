extends Node2D

var baseHP = 100
var currentHP = 100

@onready var health_bar = get_node("HealthBar")
@onready var sprite = get_node("Sprite2d")

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHP = baseHP
	health_bar.max_value = baseHP
	health_bar.value = currentHP

func repair():
	currentHP = baseHP
	
func take_dmg(damage):
	var oldColor = sprite.modulate
	currentHP -= damage
	health_bar.value = currentHP
	if currentHP <= 0:
		destroy()
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = oldColor
	
func _process(delta):
	pass
	
func destroy():
	pass
