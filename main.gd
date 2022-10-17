extends Node

var hand = [1, 2, 3, 4, 5]
var rng = RandomNumberGenerator.new()
signal update_hand(hand)

func _ready():
	rng.randomize()
	emit_signal("update_hand", hand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ui_roll(unfrozen):
	var unfrozen_id = []
	for i in range(len(unfrozen)):
		unfrozen_id.append((str(unfrozen[i].name).right(1)).to_int() - 1)
	for i in range(5):
		if i in unfrozen_id:
			hand[i] = rng.randi_range(1, 6)
	emit_signal("update_hand", hand)

