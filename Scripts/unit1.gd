extends Node2D

var sprite
var button
signal choix(coup)
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2d")
	button = get_node("Button")
	sprite.modulate = Color(0.5, 0.5, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	sprite.modulate = Color(1, 1, 1)
	button.visible = false
	emit_signal("choix", "total1")
