extends Node

var hand = [1, 2, 3, 4, 5]
var rng = RandomNumberGenerator.new()
signal update_hand(hand)

func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ui_roll(frozen):
	var frozen_id = []
	for i in range(len(frozen)):
		frozen_id.append((str(frozen[i].name).right(1)).to_int() - 1)
	for i in range(5):
		if i not in frozen_id:
			hand[i] = rng.randi_range(1, 6)
	emit_signal("update_hand", hand)
	
