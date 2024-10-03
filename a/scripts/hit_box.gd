extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisabledHitBoxTimer

func set_damage(new_damage):
	damage = new_damage  # Méthode pour définir les dégâts

func tempdisabled():
	collision.call_defered("set","disable",true)
	disableTimer.start()

func _on_disabled_hit_box_timer_timeout():
	collision.call_defered("set","disable",false)
