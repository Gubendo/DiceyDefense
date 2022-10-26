extends PathFollow2D

var baseSpeed = 150
var currentSpeed
var baseHP = 50
var currentHP
var impaired

@onready var health_bar = get_node("HealthBar")
@onready var sprite = get_node("CharacterBody2d/Sprite2d")

@onready var slow_timer = get_node("SlowTimer")

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
	if impaired:
		print("SLOW TIMER")
		print(slow_timer.time_left)
		if slow_timer.time_left == 0:
			slow_timer.stop()
			currentSpeed = baseSpeed
	
func move(delta):
	progress += currentSpeed*delta
	health_bar.position = (position - Vector2(15, 20))
	
func take_dmg(damage):
	currentHP -= damage
	health_bar.value = currentHP
	if currentHP <= 0:
		destroy()
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color(1, 1, 1)

func apply_slow(value, duration):
	currentSpeed = baseSpeed * value
	slow_timer.start(duration)
	impaired = true

func destroy():
	emit_signal("death")
	self.queue_free()
