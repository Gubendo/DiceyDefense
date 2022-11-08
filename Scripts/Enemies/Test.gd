extends PathFollow2D

var baseSpeed: float = 100
var currentSpeed: float
var baseHP: float = 50
var currentHP: float
var impaired: bool = false
var bleed: float = 0
var bleedFreq: float = 0

var blocked: bool = false
var blockedBy: Node
var atkReady: bool = true

var damage: float = 1
var cd: float = 1

@onready var health_bar: ProgressBar = get_node("HealthBar")
@onready var sprite: Sprite2D = get_node("CharacterBody2d/Sprite2d")
@onready var hitbox: CollisionShape2D = get_node("CharacterBody2d/CollisionShape2d")

@onready var slow_timer: Timer = get_node("SlowTimer")
@onready var bleed_timer: Timer = get_node("BleedTimer")
@onready var bleed_frequency: Timer = get_node("BleedFrequency")

signal death()
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	currentSpeed = baseSpeed
	currentHP = baseHP
	health_bar.max_value = baseHP
	health_bar.value = currentHP
	#health_bar.set_as_top_level(true)

func _physics_process(delta: float) -> void:
	if progress_ratio >= 1.0:
		destroy()
	if blocked:
		if blockedBy.destroyed : blocked = false
		else:
			if atkReady: attack_struct()
	else:
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
		
	
func move(delta: float) -> void:
	progress += currentSpeed*delta
	#health_bar.position = (position - Vector2(15, 20))

func take_dmg(amount: float) -> void:
	var oldColor: Color = sprite.modulate
	currentHP -= amount
	health_bar.value = currentHP
	if currentHP <= 0:
		destroy()
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = oldColor

func attack_struct() -> void:
	atkReady = false
	blockedBy.take_dmg(damage)
	take_dmg(blockedBy.thorns)
	await get_tree().create_timer(cd).timeout
	atkReady = true

func apply_slow(value: float, duration: float) -> void:
	currentSpeed = baseSpeed * value
	slow_timer.start(duration)
	impaired = true
	sprite.modulate = Color (0, 0.5, 1)
	
func apply_bleed(value: float, duration: float, freq: float) -> void:
	bleed_timer.start(duration)
	bleed = value
	bleedFreq = freq
	sprite.modulate = Color (1, 0.5, 0)

func destroy() -> void:
	emit_signal("death")
	self.queue_free()
