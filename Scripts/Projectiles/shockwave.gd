extends PathFollow2D

var damage: float
var speed: float
var direction: float
var fake_progress: float = 0

@onready var shockTemp: Resource = load("res://Scenes/Projectiles/shock.tscn")
var shock: Variant

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if progress_ratio >= 1.0 or progress_ratio <= 0:
		queue_free()
	move(delta)
	
func burst() -> void:
	shock = shockTemp.instantiate()
	shock.position = Vector2(global_position.x, global_position.y-1)
	shock.damage = damage
	$/root/Main/Temporary.add_child(shock)
	
func move(delta: float) -> void:
	fake_progress += speed*delta
	if fake_progress >= 40:
		fake_progress = 0
		progress += 25*direction
		burst()
		
	
