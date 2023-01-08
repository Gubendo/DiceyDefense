extends Container


# Video 
@onready var display_btn: OptionButton = $TabContainer/Video/MarginContainer/GridContainer/AffichageBtn
@onready var vsync_btn: CheckButton = $TabContainer/Video/MarginContainer/GridContainer/VSyncBtn

# Audio
@onready var master_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MasterSlider
@onready var music_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MusicSlider


func _ready() -> void:
	pass

func display(index: int) -> void:
	return


func vsync(button_pressed: bool) -> void:
	pass


func brightness(value: float) -> void:
	pass


func master_volume(value: float) -> void:
	pass


func music_volume(value: float) -> void:
	pass


func sfx_volume(value: float) -> void:
	pass
