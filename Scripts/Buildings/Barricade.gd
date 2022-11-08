extends Node2D

var baseHP: float = 100
var currentHP: float = 100
var thorns: float
var destroyed: bool = false

@onready var health_bar: ProgressBar = get_node("HealthBar")
@onready var sprite: Sprite2D = get_node("Sprite2d")

# Called when the node enters the scene tree for the first time.
func init() -> void:
	currentHP = baseHP
	health_bar.max_value = baseHP
	health_bar.value = currentHP

func repair() -> void:
	currentHP = baseHP
	health_bar.value = currentHP
	sprite.visible = true
	health_bar.visible = true
	destroyed = false
	
func take_dmg(damage: float) -> void:
	var oldColor: Color = sprite.modulate
	currentHP -= damage
	health_bar.value = currentHP
	if currentHP <= 0:
		destroy()
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = oldColor
	
func _process(delta: float) -> void:
	pass
	
func destroy() -> void:
	destroyed = true
	sprite.visible = false # PLUTOT CHANGER LE SPRITE
	health_bar.visible = false


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if !destroyed:
		body.owner.blocked = true
		body.owner.blockedBy = self
