extends Node2D

@onready var unit = get_node("Unit")
@onready var button = get_node("Unit/Activate")
@onready var unitHover = get_node("Unit/Hover")
@onready var range = get_node("Range")
@onready var tooltip = get_node("Tooltip")
@onready var tooltipText = get_node("Tooltip/Description")
@onready var rangeSprite = get_node("Range/RangeSprite")

@onready var stats = GameData.unit_data[unitName]["stats"]
var currentStats = []

var enemies_in_range = []
var target

var activated = false
var sleeping = false
var atkReady = true

var unitName = ""
var level = 0

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
		turn()
		if atkReady:
			attack()
	else:
		target = null

func init_sprite():
	button.modulate = Color(0.5, 0.5, 0.5)
	rangeSprite.modulate.a = 0
	unitHover.visible = false

func connect_signals():
	button.pressed.connect(activate)
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)
	button.mouse_entered.connect(enable_tooltip)
	button.mouse_exited.connect(disable_tooltip)
	
func activate():
	button.modulate = Color(1, 1, 1)
	button.disabled = true
	activated = true
	rangeSprite.modulate.a = 0.3
	emit_signal("choix", GameData.unit_data[unitName]["value"])
	update_tooltip()

func select_enemy():
	var progress_array = []
	for i in enemies_in_range:
		progress_array.append(i.progress)
	var max_progress = progress_array.max()
	var max_enemy = progress_array.find(max_progress)
	target = enemies_in_range[max_enemy]

func turn():
	unit.look_at(target.position)

func attack():
	atkReady = false
	special()
	await get_tree().create_timer(stats[level]["cooldown"]).timeout
	atkReady = true

func special(): #Dépend de chaque unité
	pass
	
func update_level(value):
	pass
	
func update_stats():
	currentStats = []
	if activated:
		for stat in stats[level]:
			currentStats.append(stat_color(stats[level][stat], 1))
	else:
		for stat in stats[0]:
			if level == 0: currentStats.append(stat_color(stats[0][stat], 1))
			else: currentStats.append(stat_color(stats[0][stat], 0))
		for idx in range(1, len(stats)):
			var statNb = 0
			for stat in stats[idx]:
				if level == idx:
					currentStats[statNb] = currentStats[statNb] + "/" + stat_color(stats[idx][stat], 1)
				else:
					currentStats[statNb] = currentStats[statNb] + "/" + stat_color(stats[idx][stat], 0)
				statNb += 1
	
	range.scale = Vector2(stats[level]["range"] + 1, stats[level]["range"] + 1)
	

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
