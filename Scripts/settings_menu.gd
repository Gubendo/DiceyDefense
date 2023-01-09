extends Container


# Video 
@onready var display_btn: OptionButton = $TabContainer/Video/MarginContainer/GridContainer/AffichageBtn
@onready var vsync_btn: CheckButton = $TabContainer/Video/MarginContainer/GridContainer/VSyncBtn
@onready var brightness_slider: HSlider = $TabContainer/Video/MarginContainer/GridContainer/BrightnessBtn
# Audio
@onready var master_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MasterSlider
@onready var music_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MusicSlider
@onready var sfx_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/SFXSlider

signal settings_open
signal settings_close

func _ready() -> void:
	close_window()
	if File.file_exists("user://save_file.save"):
		SaveSystem.load_game()
		
		display_btn.select(1 if SaveSystem.game_data["settings"]["fullscreen_on"] else 0)
		GlobalSettings.toggle_fullscreen(SaveSystem.game_data["settings"]["fullscreen_on"])
		
		vsync_btn.button_pressed = SaveSystem.game_data["settings"]["vsync_on"]
		GlobalSettings.toggle_vsync(SaveSystem.game_data["settings"]["vsync_on"])
		
		brightness_slider.value = SaveSystem.game_data["settings"]["brightness"]
		GlobalSettings.toggle_brightness(SaveSystem.game_data["settings"]["brightness"])
		
		master_slider.value = SaveSystem.game_data["settings"]["master_vol"]
		GlobalSettings.update_master_vol(SaveSystem.game_data["settings"]["master_vol"])
		
		music_slider.value = SaveSystem.game_data["settings"]["music_vol"]
		GlobalSettings.update_music_vol(SaveSystem.game_data["settings"]["music_vol"])
		
		sfx_slider.value = SaveSystem.game_data["settings"]["sfx_vol"]
		GlobalSettings.update_sfx_vol(SaveSystem.game_data["settings"]["sfx_vol"])

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap"):
		close_window()

func display(index: int) -> void:
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func vsync(button_pressed: bool) -> void:
	GlobalSettings.toggle_vsync(button_pressed)


func brightness(value: float) -> void:
	GlobalSettings.toggle_brightness(value)


func master_volume(value: float) -> void:
	GlobalSettings.update_master_vol(value)


func music_volume(value: float) -> void:
	GlobalSettings.update_music_vol(value)


func sfx_volume(value: float) -> void:
	GlobalSettings.update_sfx_vol(value)


func close_window() -> void:
	get_parent().visible = false
	emit_signal("settings_close")
	
func open_window() -> void:
	get_parent().visible = true
	emit_signal("settings_open")
