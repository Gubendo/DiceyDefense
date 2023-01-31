extends Node2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const colors = [
	Color(0, 0, 1, 1),
	Color(0, 1, 0, 1),
	Color(1, 0, 0, 1),
	Color(0, 1, 1, 1),
	Color(1, 0, 1, 1),
	Color(1, 1, 0, 1)
]

func _ready() -> void:
	rng.randomize()
	var color = colors[rng.randi() % colors.size()]
	$Particles.one_shot = true
	$Particles.emitting = true
	$Particles.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not $Particles.is_emitting():
		queue_free()
