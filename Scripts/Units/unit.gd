extends Node2D

@onready var unit: Node2D = $Unit
@onready var button: TextureButton = $Unit/Activate
@onready var unitHover: Sprite2D = $Unit/Hover
@onready var range: Area2D = $Range
@onready var tooltip: Control = $CanvasLayer/Tooltip
@onready var tooltipText: RichTextLabel = $CanvasLayer/Tooltip/Description
@onready var rangeSprite: Sprite2D = $Range/RangeSprite
@onready var lastAttack: Timer = $LastAttack
@onready var particles: CPUParticles2D = $Particles

@onready var stats: Dictionary = GameData.unit_data[unitName]["stats"]
@onready var yamsMgr: Node = get_tree().get_root().get_node("Main/YamsManager")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var status_player: AnimationPlayer = $StatusPlayer
@onready var unit_sprite: Sprite2D = $Unit/Sprite

var currentStats: Array = []

var enemies_in_range: Array = []
var target: Node
var attack_target: Node

var activated: bool = false
var sleeping: bool = false
var atkReady: bool = true
var idling: bool = false
var ranged: bool = false

var unitName: String = ""
var level: int = 0
var buff_as: float = 1
var buff_dmg: float = 1
var last_attack_time: float = 2
var damage_dealt: float = 0
var base_scale: Vector2

var save_system = SaveSystem

var debug: bool = false

signal choix(coup)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_sprite()
	connect_signals()
	disable_tooltip()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activated and enemies_in_range.size() != 0:
		select_enemy()
		show_target("")
		if target != null:
			turn(target.global_position.x - global_position.x)
			if atkReady:
				attack()
	else:
		target = null
	
	if activated and lastAttack.time_left <= 0 and !idling:
		idle_anim()
		
		

func init_sprite() -> void:
	button.modulate = Color(0.5, 0.5, 0.5)
	rangeSprite.modulate.a = 0
	unitHover.visible = false
	base_scale = unit.scale

func connect_signals() -> void:
	button.pressed.connect(activate)
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)
	button.mouse_entered.connect(enable_tooltip)
	button.mouse_exited.connect(disable_tooltip)
	choix.connect(Callable(yamsMgr, "on_unit_choice"))

	
func activate() -> void:
	if level == 0:
		save_system.game_data[unitName]["level"] = 0
		queue_free()
	else:
		particles.restart()
		on_activate()
		
		button.modulate = Color(1, 1, 1)
		button.disabled = true
		activated = true
		rangeSprite.modulate.a = 0
		update_tooltip()
		save_system.game_data[unitName]["level"] = level
		
		unit_sprite.visible = true
		button.modulate.a = 0
		
		idle_anim()
	
	emit_signal("choix", GameData.unit_data[unitName]["value"])
	
func on_activate() -> void:
	pass

### ACTION TARGET ###

func select_enemy() -> void:
	var progress_array: Array = []
	for i in enemies_in_range:
		if i != null and not i.dead:
			progress_array.append(i.progress)
	var max_progress = progress_array.max()
	var max_enemy = progress_array.find(max_progress)
	if max_enemy != -1:
		target = enemies_in_range[max_enemy]
	else:
		enemies_in_range = []
		
func get_all_enemies() -> Array:
	return get_tree().get_root().get_node("Main/KingsRoad").get_children()

func get_all_allies() -> Array:
	return get_tree().get_root().get_node("Main/Units").get_children()

func show_target(unit: String) -> void:
	if unitName == unit:
		for enemy in get_tree().get_root().get_node("Main/KingsRoad").get_children():
			if enemy == target:
				enemy.sprite.modulate = Color(0, 0, 1)
			else:
				enemy.sprite.modulate = Color(1, 1, 1)

func turn(direction: float) -> void:
	if direction < 0:
		unit.scale = Vector2(-1*base_scale.x, 1*base_scale.y)
	else:
		unit.scale = Vector2(1*base_scale.x, 1*base_scale.y)

func attack() -> void:
	atkReady = false
	attack_anim()
	await get_tree().create_timer(stats[level]["cooldown"] / buff_as).timeout
	atkReady = true

func special() -> void: #Dépend de chaque unité
	pass

func start_wave() -> void: # Dépend de chaque unité
	atkReady = true

### GESTION LVL & STATS ###
	
func update_stats() -> void:
	currentStats = []
	if activated:
		for stat in stats[level]:
			currentStats.append(stat_color(stats[level][stat], 1))
	else:
		for stat in stats[1]:
			if level == 1: currentStats.append(stat_color(stats[1][stat], 1))
			else: currentStats.append(stat_color(stats[1][stat], 0))
		for idx in range(2, len(stats) + 1):
			var statNb = 0
			for stat in stats[idx]:
				currentStats[statNb] = currentStats[statNb] + "/" + stat_color(stats[idx][stat], level==idx)
				statNb += 1
	
	if level != 0:
		range.scale = Vector2(stats[level]["range"] + 1, stats[level]["range"] + 1)
		rangeSprite.modulate = Color(1, 1, 1, 0.3)
		unitHover.modulate = Color(1, 1, 1, 1)
	else:
		range.scale = Vector2(2, 2)
		rangeSprite.modulate = Color(1, 0, 0, 0.3)
		unitHover.modulate = Color(1, 0, 0, 0.5)
	

func stat_color(stat:float, focus: bool) -> String:
	if focus:
		return "[color=fff]" + str(stat) + "[/color]"
	else:
		return "[color=5d5d5d]" + str(stat) + "[/color]"


### TOOLTIP ###

func update_tooltip() -> void:
	pass

func update_tooltip_size(size_px: int) -> void:
	var path: String = "res://Sprites/UI/tooltips/tooltip-" + str(size_px) + "px.png"
	var tooltip: Texture2D = load(path)
	$CanvasLayer/Tooltip/bg.texture = tooltip
	$CanvasLayer/Tooltip/bg.size.y = 0
	
func enable_tooltip() -> void:
	if(!sleeping):
		update_tooltip()
		tooltip.visible = true
		unitHover.visible = true
		rangeSprite.modulate.a = 0.3
		if(!activated): highlight_dices()

func disable_tooltip() -> void:
	tooltip.visible = false
	unitHover.visible = false
	if(!activated or !debug):
		rangeSprite.modulate.a = 0
	unhighlight_dices()

func highlight_dices() -> void:
	get_tree().get_root().get_node("Main/UI").highlight_dices(GameData.unit_data[unitName]["value"])
	
func unhighlight_dices() -> void:
	get_tree().get_root().get_node("Main/UI").unhighlight_dices()

### ANIMATIONS ###
func attack_anim() -> void:
	idling = false
	lastAttack.start(last_attack_time)
	attack_target = target
	
	var anim: float = animation_player.get_animation("attack").length / animation_player.playback_speed
	var attsp: float = stats[level]["cooldown"] / buff_as
	#animation_player.playback_speed = 1 / (attsp / animation_player.get_animation("attack").length)
	if anim > attsp:
		animation_player.playback_speed = (anim / attsp)*1.1
	animation_player.play("attack")
	
func idle_anim() -> void:
	animation_player.play("idle")
	idling = true
	animation_player.playback_speed = 1
	
### ### ###

func _on_range_body_entered(body: CharacterBody2D) -> void:
	if not body.get_parent().flying or ranged:
		enemies_in_range.append(body.get_parent())

func _on_range_body_exited(body: CharacterBody2D) -> void:
	if not body.get_parent().flying or ranged:
		enemies_in_range.erase(body.get_parent())
	
	
### ### ###
	

