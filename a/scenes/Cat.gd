extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 2
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $cat
@onready var hit_box = $HitBox 

func _ready():
	# Randomly choose between animations when the cat is created
	randomize()  # Initialize the random number generator


	var animation_choice = randi() % 15


	if animation_choice == 0:
		sprite.play("side_black")
		hit_box.set_damage(3)
		hp = 4
	else:
		# For other 9 chances, randomly select between calico, creme, and brown
		var other_choice = randi() % 3
		if other_choice == 0:
			sprite.play("side_calico")
		elif other_choice == 1:
			sprite.play("side_creme")
		else:
			sprite.play("side_brown")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
	
	# Flip the sprite based on the direction
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
