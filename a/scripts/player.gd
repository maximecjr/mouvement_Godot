extends CharacterBody2D

const SPEED = 100.0
const SPRINT_MULTIPLIER = 1.5  # Multiplieur pour la vitesse lors du sprint

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $caracter

var is_attacking = false  # Track if the player is currently attacking
var current_direction = "idle"  # Store the current direction

@onready var stamina_bar = $"../CanvasLayer/StaminaBar"  # Référence à la barre de stamina


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),  # Horizontal input
		Input.get_axis("ui_up", "ui_down")      # Vertical input
	)

	# Vérifier si le joueur tente de sprinter et si la stamina est suffisante
	var is_sprinting = Input.is_action_pressed("ui_sprint") and stamina_bar.stamina.value > 0  # Sprint seulement si la stamina est > 0
	var is_hitting = Input.is_action_just_pressed("ui_hit")  # Check if hit is pressed

	# Update the current direction based on input
	if direction[0] > 0:
		current_direction = "right"
	elif direction[0] < 0:
		current_direction = "left"
	elif direction[1] > 0:
		current_direction = "down"
	elif direction[1] < 0:
		current_direction = "up"
	else:
		if current_direction == "right" :
			current_direction = "idle_right"
		elif current_direction == "left" :
			current_direction = "idle_left"
		elif current_direction == "up" :
			current_direction = "idle_up"
		elif current_direction == "down" :
			current_direction = "idle_down"

	# Handle attack state
	if is_hitting and not is_attacking:
		is_attacking = true
		velocity = Vector2.ZERO  # Stop movement while attacking
		
		# Play the sword animation based on the current direction
		match current_direction:
			"right", "left","idle_left","idle_right":
				animated_sprite.play("sword_side")  # Sword attack on the side
			"down","idle_down":
				animated_sprite.play("sword_down")  # Sword attack downward
			"up","idle_up":
				animated_sprite.play("sword_up")  # Sword attack upward
		# Connect the animation finished signal to reset the attack state
		animated_sprite.connect("animation_finished", Callable(self, "_on_attack_finished"))

	elif not is_attacking:  # Only allow movement if not attacking
		# Flip the sprite horizontally based on movement direction
		if direction[0] > 0:
			animated_sprite.flip_h = false
		elif direction[0] < 0:
			animated_sprite.flip_h = true

		# Change animation based on movement direction and sprinting
		if is_sprinting and direction[0] < 0:
			animated_sprite.play("sprint_side")  # Sprint left animation
			velocity.x = direction.x * SPEED * SPRINT_MULTIPLIER
		elif is_sprinting and direction[0] > 0:
			animated_sprite.play("sprint_side")  # Sprint right animation
			velocity.x = direction.x * SPEED * SPRINT_MULTIPLIER
		elif is_sprinting and direction[1] > 0:
			animated_sprite.play("sprint_down")  # Sprint down animation
			velocity.y = direction.y * SPEED * SPRINT_MULTIPLIER
		elif is_sprinting and direction[1] < 0:
			animated_sprite.play("sprint_up")  # Sprint up animation
			velocity.y = direction.y * SPEED * SPRINT_MULTIPLIER
		elif direction.length() > 0:
			# Change the animation based on the direction
			if current_direction == "down":
				animated_sprite.play("down")  # Move down animation
			elif current_direction == "up":
				animated_sprite.play("up")  # Move up animation
			else:
				animated_sprite.play("side")  # Move side animation
		else:
			# Play idle animation based on the current direction
			match current_direction:
				"idle_down":
					animated_sprite.play("idle_down")  # Idle down animation
				"idle_up":
					animated_sprite.play("idle_up")  # Idle up animation
				"idle_left", "idle_right":
					animated_sprite.play("idle_side")  # Idle side animation
				"idle":
					animated_sprite.stop()  # If idle, stop the animation

		# Apply movement if not attacking
		if direction.length() > 0:
			direction = direction.normalized()  # Normalize to avoid faster diagonal movement
			if is_sprinting:
				velocity.x = direction.x * SPEED * SPRINT_MULTIPLIER
				velocity.y = direction.y * SPEED * SPRINT_MULTIPLIER
			else:
				velocity.x = direction.x * SPEED
				velocity.y = direction.y * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


# Callback when the attack animation is finished
func _on_attack_finished():
	is_attacking = false  # Reset the attack state
	animated_sprite.disconnect("animation_finished", Callable(self, "_on_attack_finished"))
