extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var rocketTemp: Resource = load("res://Scenes/UI/fireworks/rocket.tscn")
var rocket: Variant

func _ready() -> void:
	rng.randomize()


func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	rocket = rocketTemp.instantiate()
	rocket.position = Vector2(rng.randf_range(100, 1800), 1080)
	rocket.rotation = deg_to_rad(rng.randf_range(-5, 5))
	rocket.linear_velocity = Vector2(0, rng.randf_range(-1300, -1400))
	add_child(rocket)
