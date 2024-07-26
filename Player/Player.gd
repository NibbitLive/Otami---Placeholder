extends CharacterBody2D

const DECELERATION = 800.0 
const DASH_DECELERATION = 1500.0  # Greater deceleration when dashing

# Movement speed
@export var speed = 300.0

# Dash variables
@export var dash_speed = 600.0
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0

@onready var attack = $Attack
@onready var animation_player = $Attack  # Reference to the AnimationPlayer node

# Internal state
var is_dashing = false
var dash_time = 0.0
var dash_direction = Vector2.ZERO
var dash_timer: Timer

# Ready function to initialize the dash timer
func _ready():
	dash_timer = Timer.new()
	dash_timer.wait_time = dash_cooldown
	dash_timer.one_shot = true
	dash_timer.connect("timeout", Callable(self, "_on_DashTimer_timeout"))
	add_child(dash_timer)

# Process function runs every frame
func _process(delta):
	if is_dashing:
		# Handle dashing logic
		dash_time -= delta
		if dash_time <= 0:
			stop_dash()
		else:
			velocity = dash_direction * dash_speed
	else:
		var direction = Vector2.ZERO  # initializes the direction to zero

		# Check input and set direction accordingly
		if Input.is_action_pressed("up"):
			direction.y -= 1
		if Input.is_action_pressed("down"):
			direction.y += 1
		if Input.is_action_pressed("left"):
			direction.x -= 1
		if Input.is_action_pressed("right"):
			direction.x += 1
		
		if Input.is_action_just_pressed("dash") and not is_dashing and dash_timer.is_stopped():
			start_dash(direction)
		
		if Input.is_action_just_pressed("attack"):
			play_attack_animation()
		
		# Normalize direction to ensure consistent speed in all directions
		if direction.length() > 0:
			direction = direction.normalized()
			velocity = direction * speed
			# Adjust speed if moving diagonally
			if direction.length() != 0:
				velocity *= 0.7071  # Multiplying by 1/sqrt(2) to ensure consistent speed when moving diagonally
		else:
			# Apply deceleration
			if velocity.length() > 0:
				var decel_amount = DECELERATION * delta
				if is_dashing:
					decel_amount = DASH_DECELERATION * delta
				if velocity.length() < decel_amount:
					velocity = Vector2.ZERO
				else:
					velocity -= velocity.normalized() * decel_amount
	
	# Move the player
	move_and_slide()

# Function to start dashing
func start_dash(direction: Vector2):
	is_dashing = true
	dash_time = dash_duration
	dash_direction = direction.normalized()  # Ensure direction is normalized for consistent dash speed
	dash_timer.start()

# Function to stop dashing
func stop_dash():
	is_dashing = false
	velocity = Vector2.ZERO

# Dash timer callback
func _on_DashTimer_timeout():
	# This function is called when the dash cooldown is over
	pass

# Function to play the attack animation
func play_attack_animation():
	if animation_player.has_animation("Torch_attack"):
		animation_player.play("Torch_attack")
