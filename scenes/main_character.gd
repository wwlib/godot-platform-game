extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JET_ACCELERATION_UP = -50.00
const JET_ACCELERATION_HORIZ = 50.00
@onready var sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# This function is automatically called 60 times per second (60 fps)
func _physics_process(delta):
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle jet.
	if Input.is_action_pressed("jet-up") and velocity.y > -200:
		velocity.y += JET_ACCELERATION_UP
		
	if Input.is_action_pressed("jet-left") and velocity.x > -200 and not is_on_floor():
		velocity.x -= JET_ACCELERATION_HORIZ
		
	if Input.is_action_pressed("jet-right") and velocity.x < 200 and not is_on_floor():
		velocity.x += JET_ACCELERATION_HORIZ

	# Get the input direction (leftOrRight) and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var leftOrRight = Input.get_axis("left", "right")
	if leftOrRight and is_on_floor():
		velocity.x = leftOrRight * SPEED
	elif is_on_floor(): # stop quickly if on the floor
		velocity.x = move_toward(velocity.x, 0, 12)
	else: # stop slowly (glide) if in the air
		velocity.x = move_toward(velocity.x, 0, 4)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
