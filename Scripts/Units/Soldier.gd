extends "res://Scripts/Units/unit.gd"

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var unit_sprite: Sprite2D = get_node("Unit/Sprite")
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	unitName = "Soldier"

func activate() -> void:
	super.activate()
	unit_sprite.visible = true
	button.modulate.a = 0
	animation_player.play("idle")
	
func _process(delta):
	super._process(delta)
	
func special() -> void:
	print("PAYSAN : Je donne un coup d'épée")
	target.take_dmg(stats[level]["damage"] * buff_dmg)

func update_level(value: int) -> void:
	if value == 0: level = 0
	else: level = 1
	
func update_tooltip() -> void:
	update_stats()
	tooltipText.text = "Unité d'attaque au corps à corps qui inflige {0} points de \
dégâts toutes les {1} secondes".format([currentStats[0], currentStats[1]])
