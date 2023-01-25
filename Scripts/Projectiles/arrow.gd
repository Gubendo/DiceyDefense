extends Node2D

var start_pos: Vector2
var middle_pos: Vector2
var end_pos: Vector2
var target: Node
var t: float = 0.0

var damage: float

var speed_factor: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var direction: Vector2 = (end_pos - start_pos).normalized()
	rotation = direction.angle()# + PI/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t+= delta * speed_factor
	if t >= 1.0:
		damage_unit()
		queue_free()
	if is_instance_valid(target):
		end_pos = target.global_position
	position = quadratic_bezier(start_pos, middle_pos, end_pos, t)

func damage_unit() -> void:
	if is_instance_valid(target):
		target.take_dmg(damage)
			
func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, tau: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, tau)
	var q1: Vector2 = p1.lerp(p2, tau)
	var r: Vector2 = q0.lerp(q1, tau)
	
	return r
	
func get_all_enemies() -> Array:
	return $/root/Main/KingsRoad.get_children()
