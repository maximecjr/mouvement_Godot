extends RichTextLabel

func _ready():
	# Changer la couleur du texte en utilisant un vert plus doux (hex code)
	bbcode_enabled = true  # Assurer que BBCode est activé
	text = "[color=#59C53D]Stamina[/color]\n"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
