extends Camera2D

@export var shake_power: float
@export var shake_time: float
var isShake: bool = false
var curPos: Vector2
var elapsedtime: float = 0

func _ready() -> void:
	randomize()
	curPos = offset

func _process(delta: float) -> void:
	if isShake:
		shake(delta)

func trigger_shake(power: float, time: float, override: bool) -> void:
	if override:
		shake_power = power
		shake_time = time
		elapsedtime = 0
		isShake = true
	elif isShake == false:
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
