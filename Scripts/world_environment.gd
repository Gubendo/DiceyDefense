extends WorldEnvironment

func _ready() -> void:
	GlobalSettings.brightness_updated.connect(update_brightness)


func update_brightness(value):
	environment.adjustment_brightness = value
	print(value)
