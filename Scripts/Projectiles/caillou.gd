extends Node2D

var start_pos: Vector2
var middle_pos: Vector2
var end_pos: Vector2
var target: Node
var t: float = 0.0

var aoe_range: float
var damage: float

var speed_factor: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t+= delta * speed_factor
	if t >= 1.0:
		damage_aoe()
		queue_free()
	if is_instance_valid(target):
		end_pos = target.position
	position = quadratic_bezier(start_pos, middle_pos, end_pos, t)

func damage_aoe() -> void:
	for enemy in get_all_enemies():
		if abs(position.distance_to(enemy.position)) < aoe_range:
			enemy.take_dmg(damage)
			
func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	var r: Vector2 = q0.lerp(q1, t)
	
	return r
	
func get_all_enemies() -> Array:
	return get_tree().get_root().get_node("Main/KingsRoad").get_children()
