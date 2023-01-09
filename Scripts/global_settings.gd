extends Node

signal brightness_updated(value)

func _ready():
	pass
	
func toggle_fullscreen(value: bool) -> void:
	if value: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	SaveSystem.game_data["settings"]["fullscreen_on"] = value
	SaveSystem.save_game()

func toggle_vsync(value: bool) -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	SaveSystem.game_data["settings"]["vsync_on"] = value
	SaveSystem.save_game()
	
func toggle_brightness(value: float) -> void:
	emit_signal("brightness_updated", value)
	SaveSystem.game_data["settings"]["brightness"] = value
	SaveSystem.save_game()

func update_master_vol(vol: float) -> void:
	AudioServer.set_bus_volume_db(0, vol)
	SaveSystem.game_data["settings"]["master_vol"] = vol
	SaveSystem.save_game()
	
func update_music_vol(vol: float) -> void:
	AudioServer.set_bus_volume_db(1, vol)
	SaveSystem.game_data["settings"]["music_vol"] = vol
	SaveSystem.save_game()
	
func update_sfx_vol(vol: float) -> void:
	AudioServer.set_bus_volume_db(2, vol)
	SaveSystem.game_data["settings"]["sfx_vol"] = vol
	SaveSystem.save_game()
