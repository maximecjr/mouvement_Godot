extends CharacterBody2D

const SPEED = 100.0
const SPRINT_MULTIPLIER = 1.5
var hp = 80

@onready var animated_sprite = $caracter
@onready var hit_box = $HitBox  # Référence à l'Area2D de la hitbox de l'épée
@onready var hit_box_shape = hit_box.get_node("CollisionShape2D")  # La forme de collision de la hitbox
@onready var stamina_bar = $"../CanvasLayer/StaminaBar"

var is_attacking = false
var is_sprinting = false
var current_direction = "idle"

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	is_sprinting = Input.is_action_pressed("ui_sprint") and stamina_bar.stamina.value > 0
	var is_hitting = Input.is_action_just_pressed("ui_hit")

	# Mise à jour de la direction
	if direction[0] > 0:
		current_direction = "right"
	elif direction[0] < 0:
		current_direction = "left"
	elif direction[1] > 0:
		current_direction = "down"
	elif direction[1] < 0:
		current_direction = "up"
	else:
		if current_direction == "right":
			current_direction = "idle_right"
		elif current_direction == "left":
			current_direction = "idle_left"
		elif current_direction == "up":
			current_direction = "idle_up"
		elif current_direction == "down":
			current_direction = "idle_down"

	# Gestion de l'attaque
	if is_hitting and not is_attacking:
		is_attacking = true
		velocity = Vector2.ZERO  # Stop mouvement pendant l'attaque
		
		# Activer la hitbox au début de l'attaque
		hit_box_shape.disabled = false  # Activer la hitbox
		hit_box.set_damage(1)
		# Ajuster la position de la hitbox en fonction de la direction de l'attaque
		match current_direction:

			"right", "idle_right":
				animated_sprite.play("sword_side")
				hit_box.position = Vector2(10, 4)  # Position pour l'attaque à droite
			"left", "idle_left":
				animated_sprite.play("sword_side")
				hit_box.position = Vector2(-10, 4)  # Position pour l'attaque à gauche
			"down", "idle_down":
				animated_sprite.play("sword_down")
				hit_box.position = Vector2(0, 10)  # Position pour l'attaque vers le bas
			"up", "idle_up":
				animated_sprite.play("sword_up")
				hit_box.position = Vector2(0, -10)  # Position pour l'attaque vers le haut

		# Connecter l'animation terminée pour désactiver l'attaque
		animated_sprite.connect("animation_finished", Callable(self, "_on_attack_finished"))

	elif not is_attacking:  # Only allow movement if not attacking
		# Flip the sprite horizontally based on movement direction
		if direction[0] > 0:
			animated_sprite.flip_h = false
		elif direction[0] < 0:
			animated_sprite.flip_h = true

		# Change animation based on movement direction and sprinting
		if is_sprinting:
			# Active la hitbox lors du sprint
			hit_box_shape.disabled = false  # Activer la hitbox pour le sprint
			hit_box.set_damage(2)  # 2 dégâts pendant le sprint
			# Ajuster la position de la hitbox selon la direction de sprint
			match current_direction:
				"right":
					hit_box.position = Vector2(10, 4)  # Sprint à droite
					animated_sprite.play("sprint_side")  
				"left":
					hit_box.position = Vector2(-10, 4)  # Sprint à gauche
					animated_sprite.play("sprint_side")
				"down":
					hit_box.position = Vector2(0, 10)  # Sprint vers le bas
					animated_sprite.play("sprint_down")
				"up":
					hit_box.position = Vector2(0, -10)  # Sprint vers le haut
					animated_sprite.play("sprint_up")
		else:
			hit_box_shape.disabled = true  # Désactiver la hitbox si pas en sprint

			# Changer l'animation si non en sprint
			if direction.length() > 0:
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

# Quand l'animation d'attaque est terminée, désactiver la hitbox
func _on_attack_finished():
	is_attacking = false
	hit_box_shape.disabled = true  # Désactiver la hitbox après l'attaque
	animated_sprite.disconnect("animation_finished", Callable(self, "_on_attack_finished"))

# Quand le joueur reçoit des dégâts
func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)
	
	if hp <= 0:
		print("HP is 0! Crashing the game...")
		get_tree().quit()
