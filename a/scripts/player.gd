extends CharacterBody2D

const SPEED = 100.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $caracter

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# Handle both horizontal and vertical movement.
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),  # Horizontal input
		Input.get_axis("ui_up", "ui_down")      # Vertical input
	)

	if direction[0] > 0 :
		animated_sprite.flip_h = false
	if direction[0] < 0 :
		animated_sprite.flip_h = true

	# Change animation based on the Y axis direction
	if direction[1] > 0:
		animated_sprite.play("down")  # Change to your downward animation
	elif direction[1] < 0:
		animated_sprite.play("up")  # Change to your upward animation
	elif direction.length() > 0:
		animated_sprite.play("side")  # Horizontal movement animation
	else:
		animated_sprite.stop()  # Idle animation when not moving

		
	# Apply movement on both axes
	if direction.length() > 0:
		direction = direction.normalized()  # Normalize to avoid faster diagonal movement
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
