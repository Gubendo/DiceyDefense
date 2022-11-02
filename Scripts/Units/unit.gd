extends Node2D

@onready var unit = get_node("Unit")
@onready var button = get_node("Unit/Activate")
@onready var unitHover = get_node("Unit/Hover")
@onready var range = get_node("Range")
@onready var tooltip = get_node("Tooltip")
@onready var tooltipText = get_node("Tooltip/Description")
@onready var rangeSprite = get_node("Range/RangeSprite")

@onready var stats = GameData.unit_data[unitName]["stats"]
@onready var yamsMgr = get_tree().get_root().get_node("Main/YamsManager")
var currentStats = []

var enemies_in_range = []
var target

var activated = false
var sleeping = false
var atkReady = true

var unitName = ""
var level = 0
var buff_as = 1
var buff_dmg = 1

signal choix(coup)
# Called when the node enters the scene tree for the first time.
func _ready():
	init_sprite()
	connect_signals()
	disable_tooltip()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated and enemies_in_range.size() != 0:
		select_enemy()
		show_target("")
		turn((target.position - position).x)
		if atkReady:
			attack()
	else:
		target = null

func init_sprite():
	#button.modulate = Color(0.5, 0.5, 0.5)
	rangeSprite.modulate.a = 0
	unitHover.visible = false

func connect_signals():
	button.pressed.connect(activate)
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)
	button.mouse_entered.connect(enable_tooltip)
	button.mouse_exited.connect(disable_tooltip)
	choix.connect(Callable(yamsMgr, "on_unit_choice"))

	
func activate():
	if level == 0:
		queue_free()
	else:
		button.modulate = Color(1, 1, 1)
		button.disabled = true
		activated = true
		rangeSprite.modulate.a = 0.3
		update_tooltip()
	emit_signal("choix", GameData.unit_data[unitName]["value"])
	

### ACTION TARGET ###

func select_enemy():
	var progress_array = []
	for i in enemies_in_range:
		progress_array.append(i.progress)
	var max_progress = progress_array.max()
	var max_enemy = progress_array.find(max_progress)
	target = enemies_in_range[max_enemy]

func show_target(unit):
	if unitName == unit:
		for enemy in get_tree().get_root().get_node("Main/KingsRoad").get_children():
			if enemy == target:
				enemy.sprite.modulate = Color(0, 0, 1)
			else:
				enemy.sprite.modulate = Color(1, 1, 1)

func turn(direction):
	if direction < 0:
		unit.scale = Vector2(-1, 1)
	else:
		unit.scale = Vector2(1, 1)

func attack():
	atkReady = false
	special()
	await get_tree().create_timer(stats[level]["cooldown"] / buff_as).timeout
	atkReady = true

func special(): #Dépend de chaque unité
	pass

### GESTION LVL & STATS ###

func update_level(value):
	pass
	
func update_stats():
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
	

func stat_color(stat, focus):
	if focus:
		return "[color=fff]" + str(stat) + "[/color]"
	else:
		return "[color=5d5d5d]" + str(stat) + "[/color]"


### TOOLTIP ###

func update_tooltip():
	pass

	
func enable_tooltip():
	if(!sleeping):
		update_tooltip()
		tooltip.visible = true
		unitHover.visible = true
		rangeSprite.modulate.a = 0.3

func disable_tooltip():
	tooltip.visible = false
	unitHover.visible = false
	if(!activated):
		rangeSprite.modulate.a = 0

### ### ###

func _on_range_body_entered(body):
	enemies_in_range.append(body.get_parent())

func _on_range_body_exited(body):
	enemies_in_range.erase(body.get_parent())
