extends Node2D

@onready var unit: Node2D = get_node("Unit")
@onready var button: TextureButton = get_node("Unit/Activate")
@onready var unitHover: Sprite2D = get_node("Unit/Hover")
@onready var range: Area2D = get_node("Range")
@onready var tooltip: Control = get_node("CanvasLayer/Tooltip")
@onready var tooltipText: RichTextLabel = get_node("CanvasLayer/Tooltip/Description")
@onready var rangeSprite: Sprite2D = get_node("Range/RangeSprite")
@onready var lastAttack: Timer = get_node("LastAttack")

@onready var stats: Dictionary = GameData.unit_data[unitName]["stats"]
@onready var yamsMgr: Node = get_tree().get_root().get_node("Main/YamsManager")

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var unit_sprite: Sprite2D = get_node("Unit/Sprite")

var currentStats: Array = []

var enemies_in_range: Array = []
var target: Node
var attack_target: Node

var activated: bool = false
var sleeping: bool = false
var atkReady: bool = true
var debug: bool = false
var idling: bool = false

var unitName: String = ""
var level: int = 0
var buff_as: float = 1
var buff_dmg: float = 1
var last_attack_time: float = 2


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

func connect_signals() -> void:
	button.pressed.connect(activate)
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)
	button.mouse_entered.connect(enable_tooltip)
	button.mouse_exited.connect(disable_tooltip)
	choix.connect(Callable(yamsMgr, "on_unit_choice"))

	
func activate() -> void:
	if level == 0:
		queue_free()
	else:
		button.modulate = Color(1, 1, 1)
		button.disabled = true
		activated = true
		rangeSprite.modulate.a = 0
		update_tooltip()
		
		unit_sprite.visible = true
		button.modulate.a = 0
		idle_anim()
	
	emit_signal("choix", GameData.unit_data[unitName]["value"])
	

### ACTION TARGET ###

func select_enemy() -> void:
	var progress_array: Array = []
	for i in enemies_in_range:
		if not i.dead:
			progress_array.append(i.progress)
	var max_progress = progress_array.max()
	var max_enemy = progress_array.find(max_progress)
	target = enemies_in_range[max_enemy]

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
		unit.scale = Vector2(-1, 1)
	else:
		unit.scale = Vector2(1, 1)

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

func update_level(value: int) -> void:
	pass
	
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
	else:
		range.scale = Vector2(2, 2)
		rangeSprite.modulate = Color(1, 0, 0, 0.3)
	

func stat_color(stat:float, focus: bool) -> String:
	if focus:
		return "[color=fff]" + str(stat) + "[/color]"
	else:
		return "[color=5d5d5d]" + str(stat) + "[/color]"


### TOOLTIP ###

func update_tooltip() -> void:
	pass

	
func enable_tooltip() -> void:
	if(!sleeping):
		update_tooltip()
		tooltip.visible = true
		unitHover.visible = true
		rangeSprite.modulate.a = 0.3
		highlight_dices()

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
	enemies_in_range.append(body.get_parent())

func _on_range_body_exited(body: CharacterBody2D) -> void:
	enemies_in_range.erase(body.get_parent())
