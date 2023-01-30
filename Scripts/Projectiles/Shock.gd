extends Node2D

var damage: float

func _ready() -> void:
	$AnimationPlayer.play("burst")
	await $AnimationPlayer.animation_finished
	queue_free()


func body_entered(body: CharacterBody2D):
	if not body.get_parent().flying:
		body.get_parent().take_dmg(damage)
