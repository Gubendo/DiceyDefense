extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func play_sound() -> void:
	$AudioStreamPlayer.play()
