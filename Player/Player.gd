extends CharacterBody2D

# Movement speed
@export var speed = 200.0

# Process function runs every frame
func _process(delta):
	var direction = Vector2.ZERO #initialises the direction to zero
	
	# Check input and set direction accordingly
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	# Normalize direction to ensure consistent speed in all directions
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Set the velocity
	velocity = direction * speed

	# Move the player
	move_and_slide()
