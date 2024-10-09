extends Control

@onready var stamina = $TextureProgress
var can_regen = false
var time_to_wait = 1.5
var s_timer = 0
var can_start_timer = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_regen == false && stamina.value != 100 or stamina.value == 0:
		can_start_timer = true
		if can_start_timer:
			s_timer += delta
			if s_timer >= time_to_wait:
				can_regen = true
				can_start_timer = false
				s_timer = 0
				
	if stamina.value == 100:
		can_regen = false			
	
	if  Input.is_action_pressed("ui_sprint"):
		stamina.value -= 1
		can_regen = false
		s_timer = 0
	if can_regen == true :
		stamina.value += 2
