extends RigidBody2D

@onready var explosionTemp: Resource = load("res://Scenes/UI/fireworks/explosion.tscn")
var explosion: Variant

func _ready() -> void:
	linear_velocity = linear_velocity.rotated(rotation)
	$Tail.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if linear_velocity.y > -50:
		explosion = explosionTemp.instantiate()
		explosion.position = position
		get_parent().add_child(explosion)
		queue_free()

