extends AudioStreamPlayer

@onready var click = load("res://Sounds/UI/click3.ogg")
@onready var buttonClick = load("res://Sounds/UI/click1.ogg")
@onready var recruitUnit = load("res://Sounds/maximize_006.ogg")
@onready var discardUnit = load("res://Sounds/error_005.ogg")
@onready var diceRoll1 = load("res://Sounds/dices/diceThrow2.ogg")
@onready var diceRoll2 = load("res://Sounds/dices/dieThrow1.ogg")
@onready var diceRoll3 = load("res://Sounds/dices/dieThrow2.ogg")
@onready var diceRoll4 = load("res://Sounds/dices/dieThrow3.ogg")
@onready var diceRolls: Array = [diceRoll1, diceRoll2, diceRoll3, diceRoll4]
@onready var diceShuffle = load("res://Sounds/dices/dieGrab2.ogg")

@onready var poof = load("res://Sounds/poof.ogg")
@onready var boom = load("res://Sounds/boom.wav")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("clic_gauche"):
		click_sound()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func click_sound() -> void:
	set_stream(click)
	play()
	
func click_button() -> void:
	stop()
	set_stream(buttonClick)
	play()
	
func recruit_unit() -> void:
	stop()
	set_stream(recruitUnit)
	play()
	
func discard_unit() -> void:
	stop()
	set_stream(discardUnit)
	play()

func roll_dice() -> void:
	stop()
	set_stream(diceRolls[rng.randi() % diceRolls.size()])
	play()
	
func shuffle_dice() -> void:
	stop()
	set_stream(diceShuffle)
	play()
	
func damage_sound() -> void:
	stop()
	set_stream(boom)
	play()
	
func hover_sound() -> void:
	stop()
	set_stream(poof)
	play()

