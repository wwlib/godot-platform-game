extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const JET_ACCELERATION_UP = -1500.00
const JET_ACCELERATION_HORIZ = 1500.00
const MAX_HEALTH = 100
const MAX_FUEL = 100
const FUEL_PER_SECOND_UP = 15
const FUEL_PER_SECOND_HORIZ = 5

var points = 0
var health = MAX_HEALTH
var fuel = MAX_FUEL
var main_character_sprite_2d
var game_manager
var health_bar
var fuel_bar

var previous_y_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("main_character: ready")
	main_character_sprite_2d = %MainCharacterSprite2D
	game_manager = get_node("../../GameManager")
	print(game_manager)
	health_bar = get_node("./HealthBar")
	health_bar.set_value(health)
	fuel_bar = get_node("./FuelBar")
	fuel_bar.set_value(fuel)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func collect_item():
	add_point()
	game_manager.update_stats(points, health, fuel)


func collect_healthup():
	add_health(100)
	game_manager.update_stats(points, health, fuel)
	health_bar.set_value(health)
	

func collect_powerup():
	add_fuel(100)
	game_manager.update_stats(points, health, fuel)
	fuel_bar.set_value(fuel)


func add_point():
	points += 1
	print(points)


func add_health(amount):
	health += amount
	if (health > MAX_HEALTH):
		health = MAX_HEALTH


func add_fuel(amount):
	fuel += amount
	if (fuel > MAX_FUEL):
		fuel = MAX_FUEL

func use_fuel(amount):
	var remaining_fuel = fuel - amount
	if (remaining_fuel > 0):
		fuel = remaining_fuel
		game_manager.update_stats(points, health, fuel)
		fuel_bar.set_value(fuel)
		return true
	else:
		return false


# This function is automatically called 60 times per second (60 fps)
func _physics_process(delta):
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		main_character_sprite_2d.animation = "running"
	else:
		main_character_sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		main_character_sprite_2d.animation = "jumping"


	# Handle running Left/Right
	# Get the input direction (leftOrRight) and handle the movement/deceleration.
	# leftOrRight is -1 or 1 (left or right)
	var leftOrRight = Input.get_axis("left", "right")
	if leftOrRight and is_on_floor():
		velocity.x = leftOrRight * SPEED
	elif leftOrRight and not is_on_floor() and abs(velocity.x) < 200:
		var fuel_needed = FUEL_PER_SECOND_HORIZ * delta
		var check_fuel = use_fuel(fuel_needed)
		if (check_fuel):
			velocity.x += leftOrRight * JET_ACCELERATION_HORIZ * delta
		velocity.x += leftOrRight * JET_ACCELERATION_HORIZ * delta	
	elif is_on_floor(): # stop quickly if on the floor
		velocity.x = move_toward(velocity.x, 0, 12)
	else: # stop slowly (glide) if in the air
		velocity.x = move_toward(velocity.x, 0, 4)
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle jet.
	if Input.is_action_pressed("jet-up") and velocity.y > -200:
		var fuel_needed = FUEL_PER_SECOND_UP * delta
		var check_fuel = use_fuel(fuel_needed)
		if (check_fuel):
			velocity.y += JET_ACCELERATION_UP * delta

	move_and_slide()
	
	# Set sprite direction
	var isLeft = velocity.x < 0
	main_character_sprite_2d.flip_h = isLeft
	
	# Check for fall damage
	if (is_on_floor() and previous_y_velocity > 0):
		if (previous_y_velocity > 1500):
			health -= 30
			Input.start_joy_vibration(0,0.5,0.5,1)
		elif (previous_y_velocity > 1000):
			health -= 20
			Input.start_joy_vibration(0,0.5,0.5,1)
		elif (previous_y_velocity > 500):
			health -= 10
			Input.start_joy_vibration(0,0.5,0.5,1)
		health_bar.set_value(health)
		game_manager.update_stats(points, health, fuel)
		
		if (health <= 0):
			game_manager.game_over()

	previous_y_velocity = velocity.y

