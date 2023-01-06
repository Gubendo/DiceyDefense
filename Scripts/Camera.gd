extends Camera2D

@export var shake_power: float = 3
@export var shake_time: float = 0.2
var isShake: bool = false
var curPos: Vector2
var elapsedtime: float = 0

func _ready() -> void:
	randomize()
	curPos = offset

func _process(delta: float) -> void:
	if isShake:
		shake(delta)

func trigger_shake() -> void:
	elapsedtime = 0
	isShake = true

func shake(delta: float) -> void:
	if elapsedtime<shake_time:
		offset =  Vector2(randf(), randf()) * shake_power
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		offset = curPos   
