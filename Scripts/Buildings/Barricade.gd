extends Node2D

var baseHP = 100
var currentHP = 100
var thorns
var destroyed = false

@onready var health_bar = get_node("HealthBar")
@onready var sprite = get_node("Sprite2d")

# Called when the node enters the scene tree for the first time.
func init():
	currentHP = baseHP
	health_bar.max_value = baseHP
	health_bar.value = currentHP

func repair():
	currentHP = baseHP
	health_bar.value = currentHP
	sprite.visible = true
	health_bar.visible = true
	destroyed = false
	
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
	destroyed = true
	sprite.visible = false # PLUTOT CHANGER LE SPRITE
	health_bar.visible = false


func _on_area_2d_body_entered(body):
	if !destroyed:
		body.owner.blocked = true
		body.owner.blockedBy = self
