extends Node

const MAX_FUEL = 100

var points = 0
var fuel = MAX_FUEL
var stats_label

func add_point():
	points += 1
	print(points)
	update_stats()


func add_fuel(amount):
	fuel += amount
	if (fuel > MAX_FUEL):
		fuel = MAX_FUEL


func use_fuel(amount):
	var remaining_fuel = fuel - amount
	if (remaining_fuel > 0):
		fuel = remaining_fuel
		update_stats()
		return true
	else:
		return false


func update_stats():
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
