extends Node2D

var sprite
var button
var range

var activated
var unitName = ""
signal choix(coup)
# Called when the node enters the scene tree for the first time.
func _ready():
	activated = false
	sprite = get_node("Sprite2d")
	button = get_node("Activate")
	range = get_node("Range")
	init_sprite()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_sprite():
	sprite.modulate = Color(0.5, 0.5, 0.5)
	range.modulate.a = 0
	range.scale = Vector2(GameData.unit_data[unitName]["range"] + 1, GameData.unit_data[unitName]["range"] + 1)

func activate():
	sprite.modulate = Color(1, 1, 1)
	button.visible = false
	activated = true
	range.modulate.a = 0.3
	emit_signal("choix", GameData.unit_data[unitName]["value"])
