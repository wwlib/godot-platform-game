extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JET_ACCELERATION_UP = -1500.00
const JET_ACCELERATION_HORIZ = 1500.00
const FUEL_PER_SECOND_UP = 15
const FUEL_PER_SECOND_HORIZ = 5

var main_character_sprite_2d
var game_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	print("main_character: ready")
	main_character_sprite_2d = %MainCharacterSprite2D
	game_manager = get_node("../../GameManager")
	print(game_manager)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	var leftOrRight = Input.get_axis("left", "right")
	if leftOrRight and is_on_floor():
		velocity.x = leftOrRight * SPEED
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
		var check_fuel = game_manager.use_fuel(fuel_needed)
		if (check_fuel):
			velocity.y += JET_ACCELERATION_UP * delta
		
	if Input.is_action_pressed("jet-left") and velocity.x > -200 and not is_on_floor():
		var fuel_needed = FUEL_PER_SECOND_HORIZ * delta
		var check_fuel = game_manager.use_fuel(fuel_needed)
		if (check_fuel):
			velocity.x -= JET_ACCELERATION_HORIZ * delta
		
	if Input.is_action_pressed("jet-right") and velocity.x < 200 and not is_on_floor():
		var fuel_needed = FUEL_PER_SECOND_HORIZ * delta
		var check_fuel = game_manager.use_fuel(fuel_needed)
		if (check_fuel):
			velocity.x += JET_ACCELERATION_HORIZ * delta

	move_and_slide()
	
	# Set sprite direction
	var isLeft = velocity.x < 0
	main_character_sprite_2d.flip_h = isLeft
