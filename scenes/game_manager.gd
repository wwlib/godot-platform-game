extends Node

var stats_label

func update_stats(points, fuel):
	stats_label.text = "Points: " + str(points)
	stats_label.text += "\n"
	stats_label.text += "Fuel: " + str(floor(fuel))


# Called when the node enters the scene tree for the first time.
func _ready():
	print("game_manager: ready")
	stats_label = %StatsLabel
	print(stats_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
