extends WorldEnvironment

func _ready() -> void:
	GlobalSettings.brightness_updated.connect(update_brightness)
	GlobalSettings.glow_updated.connect(update_glow)
	environment.adjustment_enabled = true


func update_brightness(value):
	environment.adjustment_brightness = value
	
func update_glow(value):
	if value: environment.glow_hdr_threshold = 1.3
	else: environment.glow_hdr_threshold = 1.7
