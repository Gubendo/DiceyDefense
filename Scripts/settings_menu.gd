extends Container


# Video 
@onready var display_btn: OptionButton = get_node("TabContainer/Vidéo/MarginContainer/GridContainer/AffichageBtn")
@onready var vsync_btn: CheckButton = get_node("TabContainer/Vidéo/MarginContainer/GridContainer/VSyncBtn")
@onready var brightness_slider: HSlider = get_node("TabContainer/Vidéo/MarginContainer/GridContainer/BrightnessBtn")
@onready var glow_slider: HSlider = get_node("TabContainer/Vidéo/MarginContainer/GridContainer/GlowBtn")
# Audio
@onready var master_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MasterSlider
@onready var music_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MusicSlider
@onready var sfx_slider: HSlider = $TabContainer/Audio/MarginContainer/GridContainer/SFXSlider

signal settings_open
signal settings_close

func _ready() -> void:
	close_window()
	await get_tree().create_timer(0.01).timeout
	load_settings()
	
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap"):
		close_window()

func display(index: int) -> void:
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func vsync(button_pressed: bool) -> void:
	GlobalSettings.toggle_vsync(button_pressed)


func brightness(value: float) -> void:
	GlobalSettings.toggle_brightness(value)

func glow(value: float) -> void:
	GlobalSettings.toggle_glow(value)
	
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
	
func load_settings() -> void:
	if FileAccess.file_exists("user://save_file.save"):
		SaveSystem.load_game()
		
		display_btn.select(1 if SaveSystem.game_data["settings"]["fullscreen_on"] else 0)
		GlobalSettings.toggle_fullscreen(SaveSystem.game_data["settings"]["fullscreen_on"])
		
		vsync_btn.button_pressed = SaveSystem.game_data["settings"]["vsync_on"]
		GlobalSettings.toggle_vsync(SaveSystem.game_data["settings"]["vsync_on"])
		
		brightness_slider.value = SaveSystem.game_data["settings"]["brightness"]
		GlobalSettings.toggle_brightness(SaveSystem.game_data["settings"]["brightness"])
		
		glow_slider.value = SaveSystem.game_data["settings"]["glow"]
		GlobalSettings.toggle_glow(SaveSystem.game_data["settings"]["glow"])
		
		master_slider.value = SaveSystem.game_data["settings"]["master_vol"]
		GlobalSettings.update_master_vol(SaveSystem.game_data["settings"]["master_vol"])
		
		music_slider.value = SaveSystem.game_data["settings"]["music_vol"]
		GlobalSettings.update_music_vol(SaveSystem.game_data["settings"]["music_vol"])
		
		sfx_slider.value = SaveSystem.game_data["settings"]["sfx_vol"]
		GlobalSettings.update_sfx_vol(SaveSystem.game_data["settings"]["sfx_vol"])



