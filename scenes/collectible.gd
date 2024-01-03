extends Area2D

# @onready var game_manager = %GameManager
var game_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	print("collectible: ready")
	game_manager = %GameManager
	print(game_manager)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (body.name == "MainCharacter"):
		body.collect_item()
		queue_free()
