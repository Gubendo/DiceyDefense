extends PathFollow2D

var enemy_name: String
var baseSpeed: float
var currentSpeed: float
var baseHP: float
var currentHP: float
var impaired: bool = false
var bleed: float = 0
var bleedFreq: float = 0

var blocked: bool = false
var blockedBy: Node
var atkReady: bool = true
var moving: bool = false
var dead: bool = false

var damage: float
var baseCD: float
var currentCD: float
var flying: bool

@onready var health_bar: TextureProgressBar = $CharacterBody2d/HealthBar
@onready var sprite: Sprite2D = $CharacterBody2d/Sprite2d
@onready var hitbox: CollisionShape2D = $CharacterBody2d/CollisionShape2d

@onready var slow_timer: Timer = $Timers/SlowTimer
@onready var bleed_timer: Timer = $Timers/BleedTimer
@onready var bleed_frequency: Timer = $Timers/BleedFrequency

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var status_player: AnimationPlayer = $StatusPlayer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal death(nexus_dmg)
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	baseSpeed = GameData["enemies_stats"][enemy_name]["speed"]
	baseHP = GameData["enemies_stats"][enemy_name]["health"]
	damage = GameData["enemies_stats"][enemy_name]["damage"]
	baseCD = GameData["enemies_stats"][enemy_name]["cd"]
	flying = GameData["enemies_stats"][enemy_name]["flying"]
	currentSpeed = baseSpeed
	currentHP = baseHP
	currentCD = baseCD
	health_bar.max_value = baseHP
	health_bar.value = currentHP
	rng.randomize()
	#health_bar.set_as_top_level(true)

func _physics_process(delta: float) -> void:
	if progress_ratio >= 1.0 and not dead:
		destroy(false)
		
	if dead:
		pass
	elif blocked:
		if blockedBy != null and blockedBy.destroyed and !animation_player.is_playing(): blocked = false
		else:
			moving = false
			if atkReady: 
				animation_player.play("attack")
			elif animation_player.current_animation == "run":
				animation_player.play("RESET")
	else:
		if !moving:
			animation_player.play("run")
			animation_player.seek(rng.randf_range(0, animation_player.get_animation("run").length))
		moving = true
		move(delta)
	
	if impaired and slow_timer.time_left <= 0:
		slow_timer.stop()
		currentSpeed = baseSpeed
		currentCD = baseCD
		animation_player.playback_speed = 1
		sprite.modulate = Color(1, 1, 1)
		impaired = false
	if bleedFreq != 0 and bleed != 0 and bleed_frequency.time_left == 0:
		take_dmg(bleed)
		if not dead:
			if bleed_timer.time_left <= 0:
				bleedFreq = 0
				bleed = 0
				status_player.play("RESET")
			else:
				bleed_frequency.start(bleedFreq)
		
	
func move(delta: float) -> void:
	progress += currentSpeed*delta
	#health_bar.position = (position - Vector2(15, 20))

func take_dmg(amount: float) -> void:
	var oldColor: Color = sprite.modulate
	if oldColor == Color(1, 0, 0): oldColor = Color(1, 1, 1)
	currentHP -= amount
	health_bar.value = currentHP
	if currentHP <= 0:
		destroy(true)
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = oldColor

func attack_struct() -> void:
	atkReady = false
	blockedBy.take_dmg(damage)
	take_dmg(blockedBy.thorns)
	await get_tree().create_timer(currentCD).timeout
	atkReady = true

func apply_slow(value: float, duration: float) -> void:
	currentSpeed = baseSpeed * value
	currentCD = baseCD * value
	animation_player.playback_speed = value
	slow_timer.start(slow_timer.time_left + duration)
	impaired = true
	sprite.modulate = Color (0.5, 1, 1)
	
func apply_bleed(value: float, duration: float, freq: float) -> void:
	if not dead:
		bleed_timer.start(duration)
		if bleed != 0:
			bleed = bleed + 0.5*value
		else:
			bleed = value
		bleedFreq = freq
		status_player.play("bleed")

func destroy(killed: bool) -> void:
	if not dead:
		$CharacterBody2d.visible = false
		$Bleed.visible = false
		dead = true
		
		if killed:
			emit_signal("death", 0)
			status_player.play("death")
			await status_player.animation_finished
			self.queue_free()
		else:
			emit_signal("death", GameData["enemies_stats"][enemy_name]["nexus_dmg"])
			self.queue_free()
		
