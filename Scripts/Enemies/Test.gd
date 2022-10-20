extends PathFollow2D

var speed = 150
# Called when the node enters the scene tree for the first time.
	
func _physics_process(delta):
	move(delta)
	
func move(delta):
	progress += speed*delta
