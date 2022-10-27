extends PathFollow2D

var baseSpeed = 100
var currentSpeed
var baseHP = 50
var currentHP
var impaired = false
var bleed = 0
var bleedFreq = 0

@onready var health_bar = get_node("HealthBar")
@onready var sprite = get_node("CharacterBody2d/Sprite2d")

@onready var slow_timer = get_node("SlowTimer")
@onready var bleed_timer = get_node("BleedTimer")
@onready var bleed_frequency = get_node("BleedFrequency")

signal death()
# Called when the node enters the scene tree for the first time.

func _ready():
	currentSpeed = baseSpeed
	currentHP = baseHP
	health_bar.max_value = baseHP
	health_bar.value = currentHP
	health_bar.set_as_top_level(true)

func _physics_process(delta):
	if progress_ratio >= 1.0:
		destroy()
	move(delta)
	
	if impaired and slow_timer.time_left == 0:
		slow_timer.stop()
		currentSpeed = baseSpeed
		sprite.modulate = Color(1, 1, 1)
		impaired = false
	if bleedFreq != 0 and bleed != 0 and bleed_frequency.time_left == 0:
		take_dmg(bleed)
		if bleed_timer.time_left == 0:
			bleedFreq = 0
			bleed = 0
			sprite.modulate = Color(1, 1, 1)
		else:
			bleed_frequency.start(bleedFreq)
		
	
func move(delta):
	progress += currentSpeed*delta
	health_bar.position = (position - Vector2(15, 20))
	
func take_dmg(damage):
	var oldColor = sprite.modulate
	currentHP -= damage
	health_bar.value = currentHP
	if currentHP <= 0:
		destroy()
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = oldColor

func apply_slow(value, duration):
	currentSpeed = baseSpeed * value
	slow_timer.start(duration)
	impaired = true
	sprite.modulate = Color (0, 0.5, 1)
	
func apply_bleed(value, duration, freq):
	bleed_timer.start(duration)
	bleed = value
	bleedFreq = freq
	sprite.modulate = Color (1, 0.5, 0)

func destroy():
	emit_signal("death")
	self.queue_free()
