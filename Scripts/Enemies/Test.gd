extends PathFollow2D

var speed = 150
var hp = 50

@onready var health_bar = get_node("HealthBar")
signal death()
# Called when the node enters the scene tree for the first time.

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)

func _physics_process(delta):
	if progress_ratio >= 1.0:
		print("take dmg")
		destroy()
	move(delta)
	
func move(delta):
	progress += speed*delta
	health_bar.position = (position - Vector2(15, 20))
	
func take_dmg(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		destroy()

func destroy():
	emit_signal("death")
	self.queue_free()
