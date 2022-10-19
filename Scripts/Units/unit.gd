extends Node2D

var sprite
var button

var activated
var value = ""
signal choix(coup)
# Called when the node enters the scene tree for the first time.
func _ready():
	activated = false
	sprite = get_node("Sprite2d")
	button = get_node("Activate")
	sprite.modulate = Color(0.5, 0.5, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func activate():
	sprite.modulate = Color(1, 1, 1)
	button.visible = false
	activated = true
	emit_signal("choix", value)
