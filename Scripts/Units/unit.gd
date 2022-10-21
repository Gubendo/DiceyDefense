extends Node2D

@onready var sprite = get_node("Sprite2d")
@onready var button = get_node("Activate")
@onready var range = get_node("Range")
@onready var rangeSprite = get_node("Range/RangeSprite")

var enemies_in_range = []
var target

var activated = false
var atkReady = true

var unitName = ""
signal choix(coup)
# Called when the node enters the scene tree for the first time.
func _ready():
	init_sprite()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated and enemies_in_range.size() != 0:
		select_enemy()
		turn()
		if atkReady:
			attack()
	else:
		target = null

func init_sprite():
	sprite.modulate = Color(0.5, 0.5, 0.5)
	rangeSprite.modulate.a = 0
	range.scale = Vector2(GameData.unit_data[unitName]["range"] + 1, GameData.unit_data[unitName]["range"] + 1)

func activate():
	sprite.modulate = Color(1, 1, 1)
	button.visible = false
	activated = true
	rangeSprite.modulate.a = 0.3
	emit_signal("choix", GameData.unit_data[unitName]["value"])

func select_enemy():
	var progress_array = []
	for i in enemies_in_range:
		progress_array.append(i.progress)
	var max_progress = progress_array.max()
	var max_enemy = progress_array.find(max_progress)
	target = enemies_in_range[max_enemy]

func turn():
	sprite.look_at(target.position)

func attack():
	atkReady = false
	special()
	await get_tree().create_timer(GameData.unit_data[unitName]["cooldown"]).timeout
	atkReady = true

func special(): #Dépend de chaque unité
	pass
	
func _on_range_body_entered(body):
	enemies_in_range.append(body.get_parent())

func _on_range_body_exited(body):
	enemies_in_range.erase(body.get_parent())
